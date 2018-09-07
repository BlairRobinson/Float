//
//  UserTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 28/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var user: User! {
        didSet {
            ImageService.getImage(withURL: user.profileURL) { (image) in
                self.profilePic.image = image
            }
            nameLabel.text = user.fullName
            emailLabel.text = user.email
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePic.layer.cornerRadius = profilePic.frame.height / 2.0
    }

}
