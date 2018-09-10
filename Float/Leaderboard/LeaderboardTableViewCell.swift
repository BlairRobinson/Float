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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var by_Who: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    
    override func layoutSubviews() {
        self.profile_pic.layer.cornerRadius = self.profile_pic.frame.height / 2.0
    }
    
    var float: Float! {
        didSet{
            ImageService.getImage(withURL: float.user.profileURL) { (image) in
                self.profile_pic.image = image
            }
            title.text = float.title
            by_Who.text = float.user.fullName
            likes.text = String(float.peopleWholikes.count - 1)
        }
    }
}
