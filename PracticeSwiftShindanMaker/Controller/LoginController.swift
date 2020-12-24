//
//  LoginController.swift
//  PracticeSwiftShindanMaker
//
//  Created by Kenshiro on 2020/12/22.
//

import UIKit
//Twitterログインするために使う
import FirebaseAuth
//ローディングのアニメーションを出す
import NVActivityIndicatorView


class LoginController: UIViewController {
    
    //OAuthProviderをインスタンス化
    var provider:OAuthProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Twitterログインの機能を使えるようにした(https://qiita.com/TakahikoKawasaki/items/e37caf50776e00e733be)
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        //表示言語を日本語化
        provider?.customParameters = [ "loang":"ja"]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        //ナビゲーションコントラーを非表示にする(戻れないようにして二重ログインを防ぐ)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func TwitterLogin(_ sender: Any) {
        
        //Twitterログインの機能を使えるようにした(https://qiita.com/TakahikoKawasaki/items/e37caf50776e00e733be)
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        
        //強制ログインを許可
        provider?.customParameters = [ "force_login":"true"]
        
        //ログインの設定
        provider?.getCredentialWith(nil, completion: {(credential,error)in
                //ActivityIndicatorView(レーディング時のアニメーション)の設定をする
            let activityView = NVActivityIndicatorView(frame: self.view.bounds,type: .lineSpinFadeLoader,color:.gray,padding: .none)
                    //activityViewをviewに追加
                self.view.addSubview(activityView)
                    //activityViewのアニメーションを開始
                activityView.startAnimating()
            
                //ログインの処理をする
                Auth.auth().signIn(with: credential!){(result, error) in
                    //エラーが出た場合に処理を止める
                    if error != nil{
                        return
                    }
                    //activityViewのアニメーションを終了(ここまで来るとログイン処理が完了しているため)
                    activityView.stopAnimating()
                    
                //画面遷移させる
                    var im = 1
            }
        })
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
