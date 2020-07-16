//
//  dayViewController.swift
//  Caren
//
//  Created by 須田　知弘 on 2020/06/26.
//  Copyright © 2020 tomohiro.suda. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class dayViewController: UIViewController, UITableViewDelegate,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel?.text = taskArray[indexPath.row]
        
        return cell
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var coutentsLabel: UILabel!
    @IBOutlet weak var inputDayLabel: UILabel!
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    
//    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    var task: Task!
    
  
        

   // invalidateLayoutCache
    
        let realm = try! Realm()
     var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
     //   MSSectionLayoutTypeHorizontalTile
  
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //MARK:segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let oneViewController:OneViewController = segue.destination as! OneViewController

           if segue.identifier == "cellSegue" {
               let indexPath = self.tableView.indexPathForSelectedRow
               oneViewController.task = taskArray[indexPath!.row]
           } else {
               let task = Task()

               let allTasks = realm.objects(Task.self)
               if allTasks.count != 0 {
                   task.id = allTasks.max(ofProperty: "id")! + 1
               }

               oneViewController.task = task
           }
       }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          // --- ここから ---
          if editingStyle == .delete {
              // 削除するタスクを取得する
              let task = self.taskArray[indexPath.row]

              // ローカル通知をキャンセルする
              let center = UNUserNotificationCenter.current()
              center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

              // データベースから削除する
              try! realm.write {
                  self.realm.delete(task)
                  tableView.deleteRows(at: [indexPath], with: .fade)
              }

              // 未通知のローカル通知一覧をログ出力
              center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                  for request in requests {
                      print("/---------------")
                      print(request)
                      print("---------------/")
                  }
              }
          }
    }
//    // セルの内容を返すメソッド
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    }
//    // セルの行数を返すメソッド
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    }

}
