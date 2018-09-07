//
//  MessagesTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 29/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exampleText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    override func layoutSubviews() {
        profilePic.layer.cornerRadius = profilePic.frame.height / 2.0
    }
    
    var message: Message! {
        didSet {
            setUpNameAndAvatar()
            self.exampleText.text = message.text
            let seconds = Double(message.timeStamp)
            let timestamp = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            self.timeLabel.text = dateFormatter.string(from: timestamp)
        }
    }
    
    private func setUpNameAndAvatar() {
       
        let ref = Database.database().reference().child("users").child("profile").child(message.chatPartnerId()!)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any],
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string: photoURL){
                ImageService.getImage(withURL: url) { (image) in
                    self.profilePic.image = image
                }
                self.nameLabel.text = dict["name"] as? String
            }
        }
    }
}
