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
        
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
