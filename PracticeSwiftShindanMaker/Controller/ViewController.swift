//
//  ViewController.swift
//  PracticeSwiftShindanMaker
//
//  Created by Kenshiro on 2020/12/22.
//

import UIKit
//トランジションを表示させる
import BubbleTransition
//Firebaseを使う(XML解析の際に使用)
import Firebase

class FeedItem{
    var meigen:String!
    var auther:String!
}

class ViewController: UIViewController,
                      //トランジションを使う
                      UIViewControllerTransitioningDelegate,
                      //XMLパースをする際に必要な
                      XMLParserDelegate {
    
    //LoginControllerから持って来たいTwitterのユーザー名をインスタンス化
    var userName = String()
    
    var feedItem = [FeedItem]()
    var currentElementName: String!
    
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    @IBOutlet weak var goToFeed: UIButton!
    
    
    let db = Firestore.firestore()
    var parser = XMLParser()
    
    //BubbleTransitionのトランジションを使うための設定(https://github.com/andreamazz/BubbleTransition)
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    // viewが表示される直前に呼ばれる処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ボタンの形状を編集
        goToFeed.layer.cornerRadius = goToFeed.frame.width/2
        
        //ナビゲーションバーを消す
        self.navigationController?.isNavigationBarHidden = true
        
        //XML解析をする
            //httpのサイトからデータを持ってくるのでinfo.plistでAllow Arbitrary LoadsをYESで設定する必要がある
        let url = "thhp://meigen.doodlenote.net/api?c=1"
            //String型のurlをURL型の変数に変更
        let urlToSend = URL(string: url)
            //パーサーの設定
        parser = XMLParser(contentsOf: urlToSend!)!
        parser.delegate = self
        parser.parse()
    }
    
    //XML解析をする(読み込んだurlのXMLデータを上から順番に解析する)
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "data" {
                //elementNameがdataの行を解析した場合には、feedItemに値が空のFeedItemを追加する
                self.feedItem.append(FeedItem())
        }
        else{
            //解析した行(elementName)の値をcurrentElementNameに入れる
            currentElementName = elementName
        }
    }
    
    //<meigen></meigen>内 or <auther></auther>内それぞれに含まれる文字を取り出す(わからなければセクション280見る)
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //feedItemにFeedItemのが追加されている場合の処理
        if  self.feedItem.count > 0{
               
            //meigenLabelに反映させるfeedItem型の変数を設定
            let lastItem = self.feedItem[self.feedItem.count - 1]
            
            //crrentElementNameから上のdidStartElementで解析したデータがmeigenかautherかを判別してcase分け
            switch self.currentElementName{
                case "meigen":
                    //lastItemに名言(キー値はmeigen)を保存
                    lastItem.meigen = string
                    
                case "auther":
                    //lastItemに著作名(キー値はauther)を保存
                    lastItem.auther = string
                    
                    //meigenLabelにlastItemの値を反映(XMLの構造上autherが呼ばれた段階で必要なXML解析が終了したとみなすためここに記載してる)
                        //「\n」は改行の意
                    meigenLabel.text = lastItem.meigen + "\n" + lastItem.auther
                    
                default:break
            }
        }
    }
    
    //XML解析を終了する
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //次回のxml解析に備えてcurrentElementNameを空にする
        currentElementName = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func TwitterShare(_ sender: Any) {
        
        var postString = "\(userName)さんを表す名言:\n\(meigenLabel.text!)\n#あなたを表す名言メーカー"
        
        let shareItems = [postString] as [String]
        
        //Twitterシェア用のアクティビティVCを設定
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        //アクティビティVCを出す
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func TLShare(_ sender: Any) {
        //quoteとuserNameがnilじゃない場合に処理を行う
        if let quote = meigenLabel.text,let userName = Auth.auth().currentUser?.uid{
            
            //db(firestore)に値を保存する
            //Twittereのユーザーネームとアイコン(absoluteStringでString型に変換)、名言の3つのデータを保存している
            db.collection("feed").addDocument(data: ["userName":Auth.auth().currentUser?.displayName,"photoUrl":Auth.auth().currentUser?.photoURL?.absoluteString,"quote":meigenLabel.text,"createdAt":Date().timeIntervalSince1970],
                //エラー時の処理
                completion: {(error)in
                if error != nil{
                    print(error.debugDescription)
                    return
                    }
                })
        }
        
    }
    
    @IBAction func gotoFeedVC(_ sender: Any) {
        //モーダルで画面遷移する呪文
        performSegue(withIdentifier:  "feedVC", sender: nil)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}

