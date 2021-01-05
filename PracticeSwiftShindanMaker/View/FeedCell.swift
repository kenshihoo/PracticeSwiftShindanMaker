//
//  FeedCell.swift
//  PracticeSwiftShindanMaker
//
//  Created by Kenshiro on 2021/01/03.
//

import UIKit

class FeedCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    
    //セルが構築された際に呼ばれるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //セル内の各要素のデザインを設定
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
                self.contentView.layer.masksToBounds = true
                self.contentView.layer.cornerRadius = 10.0
                
                //セル自体のデザインを設定
                self.layer.masksToBounds = false
                self.layer.shadowOffset = CGSize(width: 2, height: 4)
                self.layer.shadowRadius = 10.0
                self.layer.shadowOpacity = 0.5
                
                //topViewの色をランダムに設定
                let randomDouble1 = CGFloat.random(in: 0.0...1.0)
                let randomDouble2 = CGFloat.random(in: 0.0...1.0)
                let randomDouble3 = CGFloat.random(in: 0.0...1.0)
                self.topView.backgroundColor = UIColor(red: randomDouble1, green: randomDouble2, blue: randomDouble3, alpha: 1.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
