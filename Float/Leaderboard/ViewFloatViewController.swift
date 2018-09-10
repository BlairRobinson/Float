//
//  ViewFloatViewController.swift
//  Float
//
//  Created by Blair Robinson on 15/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class ViewFloatViewController: UIViewController {

    var float: Float!
    var hasDisliked:Bool = true
    let cUId = Auth.auth().currentUser!.uid
    var ranked: Int!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var writtenBy: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardColour: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageService.getImage(withURL: float.user.profileURL) { (image) in
            self.profileImage.image = image
        }
        self.writtenBy.text = float.user.fullName
        self.timestamp.text = FloatTableViewCell.convertTimestamp(serverTimestamp: float.timestamp)
        self.text.text = float.float_idea
        self.likes.text = String(float.likes)
        self.comments.text = String(float.comments)
        self.rank.text = String(ranked)
        
        if float.peopleWholikes.contains(cUId){
            hasDisliked = false
            likeBtn.setImage(UIImage(named: "LikeBtnPressed"), for: .normal)
        } else {
            hasDisliked = true
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
        }
        
        self.profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        card.layer.cornerRadius = 10
        cardColour.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.8)
        cardColour.layer.cornerRadius = 10
        cardColour.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        card.layer.shadowOpacity = 0.5
        card.layer.shadowRadius = 4.0
    }
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        if hasDisliked {
            hasDisliked = false
            likeBtn.setImage(UIImage(named: "LikeBtnPressed"), for: .normal)
            likes.text = String(float.likes)
        } else {
            hasDisliked = true
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
            likes.text = String(float.likes - 1)
        }
        float.like()
    }
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        CommentTableViewController.floatId = float.id
    }
    
}
