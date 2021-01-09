//
//  FeedViewController.swift
//  PracticeSwiftShindanMaker
//
//  Created by Kenshiro on 2021/01/03.
//

import UIKit
import BubbleTransition
import Firebase
import FirebaseFirestore
import SDWebImage
import ViewAnimator

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var interactiveTransition = BubbleInteractiveTransition()
    
    //テーブルビューを設定
    @IBOutlet weak var tableView: UITableView!
    
    //firestore内のデータをインスタンス化
    let db = Firestore.firestore()
    //構造体であるFeedsをインスタンス化
    var feeds:[Feeds] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを作る
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        tableView.separatorStyle = .none
        
        
        loadData()
    }
    
    func loadData()  {
        //firestoreに保存された投稿データを受信
        db.collection("feed").order(by:"createdAt").addSnapshotListener{(snapShot,error) in
            
            
            self.feeds = []
            //エラーが出たらエラー理由をprintして処理終了
            if error != nil{
                return
            }
            //snapShotのドキュメントがnilでなかった場合にsnapShot内のデータを取得する
            if let snapShotDoc = snapShot?.documents{
                
                //保存されてるデータの数(snapShotDocの数)だけfor文回す
                for doc in snapShotDoc{
                    let data = doc.data()
                    
                    if let userName = data["userName"] as? String,let quote = data["quote"] as? String,let photoUrl = data["photoUrl"] as? String{
                        
                        let newFeeds = Feeds(userName:userName,quote:quote,profileURL: photoUrl)
                        
                        self.feeds.append(newFeeds)
                        //feedsの表示順を新しいものを最初に設定
                        self.feeds.reverse()
                        
                        //非同期処理させる呪文
                        DispatchQueue.main.async {
                            self.tableView.tableFooterView = nil
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        //モーダルを解除して画面を戻る呪文
         dismiss(animated: true, completion: nil)
        
        interactiveTransition.finish()
    }
    
    //作成必要なセルの数をカウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    //セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell",for: indexPath) as! FeedCell
        
//        cell.userNameLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言"
        cell.quoteLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言" + "\n" + feeds[indexPath.row].quote
        
        cell.profileImageView.sd_setImage(with: URL(string: feeds[indexPath.row].profileURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セル上部の余白の高さを設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.size.height/10
    }
    
    //余白の色を設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        
        return marginView
    }
    
    //セル下部の余白のサイズを設定
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //余白をなしで設定
        return .leastNonzeroMagnitude
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
