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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var writtenBy: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    
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
        
        if float.peopleWholikes.contains(cUId){
            hasDisliked = false
            likeBtn.setImage(UIImage(named: "LikeBtnPressed"), for: .normal)
        } else {
            hasDisliked = true
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
        }
        
        self.profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
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
