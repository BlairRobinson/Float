//
//  LeaderboardTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 10/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var written_by: UILabel!
    @IBOutlet weak var when_written: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    
    override func layoutSubviews() {
        self.profile_pic.layer.cornerRadius = self.profile_pic.frame.height / 2.0
    }
    
    var float: Float! {
        didSet{
            ImageService.getImage(withURL: float.user.profileURL) { (image) in
                self.profile_pic.image = image
            }
            written_by.text = float.user.fullName
            when_written.text = FloatTableViewCell.convertTimestamp(serverTimestamp: float.timestamp)
            likes.text = String(float.peopleWholikes.count - 1)
        }
    }
}
