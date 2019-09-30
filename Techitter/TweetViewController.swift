
//
//  TweetViewController.swift
//  Techitter
//
//  Created by 笠原未来 on 2019/09/23.
//  Copyright © 2019 笠原未来. All rights reserved.
//

import UIKit
import Firebase

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userNameLabel: UILabel!
    
//    var me : AppUser! // 自身のユーザーデータ
    var userName: String!
    
    var database: DatabaseReference!

//    var currentText: String! = ""
    
//    var tweetArray: [String] = []
    
    var contentArray: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = userName
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        database = Database.database().reference()// インスタンスの取得
        
        read()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        database.removeAllObservers()
    }
    
    @IBAction func send() {
        create()
        tableView.reloadData()
        textField.text = ""
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.contentLabel?.numberOfLines = 0
        
        //配列の該当のデータをitemという定数に代入
        let item = contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! [String:AnyObject]
         //nameという添字で保存していたユーザー名を表示
        cell.userNameLabel.text = String(describing: content["name"]!)
         //messageという添字で保存していた投稿内容を表示
        cell.contentLabel.text = String(describing: content["message"]!)
        
        return cell
    }
    
    func create() {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard textField.text != nil else { return }
        
        let name: String! = userNameLabel.text
        let message = textField.text
        
        let data = ["name": name, "message": message]
        database.child("message").childByAutoId().setValue(data)
    }
    
    func read() {
        database.child("message").observe(.value, with: {(snapshots) in
            if snapshots.children.allObjects is [DataSnapshot]{
                print("snapShots.children...\(snapshots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapshots)") //読み込んだデータをプリント
                
                self.snap = snapshots
            }
            self.reload(snap: self.snap)
        })
    }
    
    // キーボードを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            //DataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            database.child("message").keepSynced(true)
            //テーブルビューをリロード
            tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
