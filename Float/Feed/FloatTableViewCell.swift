//
//  FloatTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 09/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class FloatTableViewCell: UITableViewCell {
    
    let red = UIColor(red: 255/255, green: 74/255, blue: 0/255, alpha: 1)
    let cUId = Auth.auth().currentUser!.uid
    var hasDisliked:Bool = true
    var currentLikes: Int!
    
    @IBOutlet weak var float_written_by: UILabel!
    @IBOutlet weak var float_when_written: UILabel!
    @IBOutlet weak var float_description: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var float_likes: UILabel!
    @IBOutlet weak var float_comments: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardColour: UIView!
    

    @IBAction func commentBtnPressed(_ sender: Any) {
        CommentTableViewController.floatId = float.id
    }
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        if hasDisliked {
            hasDisliked = false
            likeBtn.setImage(UIImage(named: "LikeBtnPressed"), for: .normal)
            currentLikes = currentLikes + 1
            float_likes.text = String(currentLikes)
            AudioServicesPlaySystemSound(1519)
        } else {
            hasDisliked = true
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
            currentLikes = currentLikes - 1
            float_likes.text = String(currentLikes)
        }
        float.like()
    }
    
    override func layoutSubviews() {
        self.profilePic.layer.cornerRadius = profilePic.frame.height / 2.0
        self.selectionStyle = UITableViewCellSelectionStyle.none
        card.layer.cornerRadius = 10
        cardColour.layer.cornerRadius = 10
        cardColour.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        card.layer.shadowOpacity = 0.4
        card.layer.shadowRadius = 4.0
        if float.peopleWholikes.contains(cUId){
            hasDisliked = false
           likeBtn.setImage(UIImage(named: "LikeBtnPressed"), for: .normal)
        } else {
            hasDisliked = true
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
        }
        
    }
    
    var float: Float!{
        didSet{
            ImageService.getImage(withURL: float.user.profileURL) { (image) in
                self.profilePic.image = image
            }
            
            float_written_by.text = float.user.fullName
            float_when_written.text = FloatTableViewCell.convertTimestamp(serverTimestamp: float.timestamp)
            float_description.text = float.float_idea
            float_likes.text = String(float.likes)
            float_comments.text = String(float.comments)
            currentLikes = float.likes
            cardColour.backgroundColor = float.color
        }
    }
    
    var ranked: Int! {
        didSet{
            self.rank.text = String(ranked)
        }
    }
    
    public static func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter.string(from: date as Date)
    }
    
}




