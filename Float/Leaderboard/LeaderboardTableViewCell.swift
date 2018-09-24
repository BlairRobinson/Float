//
//  LeaderboardTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 10/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardTableViewCell: UITableViewCell {
    
    let cUId = Auth.auth().currentUser!.uid
    var hasDisliked:Bool = true
    
    @IBOutlet weak var float_written_by: UILabel!
    @IBOutlet weak var float_when_written: UILabel!
    @IBOutlet weak var float_description: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var float_likes: UILabel!
    @IBOutlet weak var float_comments: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var profileBackground: UIView!
    
    
    override func layoutSubviews() {
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2.0
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        card.layer.shadowOpacity = 0.4
        card.layer.shadowRadius = 4.0
        profileBackground.layer.cornerRadius = profileBackground.frame.height / 2.0
        profileBackground.layer.shadowColor = UIColor.black.cgColor
        profileBackground.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        profileBackground.layer.shadowOpacity = 0.4
        profileBackground.layer.shadowRadius = 4.0
        if float.peopleWholikes.contains(cUId){
            hasDisliked = false
            float_likes.textColor = UIColor(red: 255/255, green: 2/255, blue: 0/255, alpha:1)
            float_likes.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            hasDisliked = true
            float_likes.textColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha:1)
        }
    }
    
    var float: Float! {
        didSet{
            ImageService.getImage(withURL: float.user.profileURL) { (image) in
                self.profilePic.image = image
            }
            float_comments.text = String(float.comments)
            float_written_by.text = float.user.fullName
            float_likes.text = String(float.peopleWholikes.count - 1)
            float_description.text = float.float_idea
            float_when_written.text = FloatTableViewCell.convertTimestamp(serverTimestamp: float.timestamp)
        }
    }
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        CommentTableViewController.floatId = float.id
        CommentTableViewController.viewController = "Leaderboard"
    }
}
