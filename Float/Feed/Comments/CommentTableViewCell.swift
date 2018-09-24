//
//  CommentTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 13/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var writtenBy: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var profileBackground: UIView!
    @IBOutlet weak var card: UIView!
    
    var comment: Comment!{
        didSet {
            ImageService.getImage(withURL: comment.profileURL) { (image) in
                self.profileImage.image = image
            }
            
            self.writtenBy.text = comment.author
            self.commentText.text = comment.text
            self.timestamp.text = FloatTableViewCell.convertTimestamp(serverTimestamp: comment.timestamp)
        }
    }
    
    override func layoutSubviews() {
        self.profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
        profileBackground.layer.cornerRadius = profileBackground.frame.height / 2.0
        profileBackground.layer.shadowColor = UIColor.black.cgColor
        profileBackground.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        profileBackground.layer.shadowOpacity = 0.4
        profileBackground.layer.shadowRadius = 4.0
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        card.layer.shadowOpacity = 0.3
        card.layer.shadowRadius = 4.0
    }
}
