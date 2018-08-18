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
    }
}
