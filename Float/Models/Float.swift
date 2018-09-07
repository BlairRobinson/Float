//
//  Float.swift
//  Float
//
//  Created by Blair Robinson on 07/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class Float
{
    var id:String
    var title: String
    var float_idea = ""
    var user: User
    var timestamp: Double
    var peopleWholikes: [String] = [String]()
    var comments = 0
    var likes = 0
    var category: String
    var color: UIColor
    
    init(id: String, title: String, float_idea: String, user: User, timestamp: Double, peopleWholikes: [String], comments: Int, likes: Int, category: String)
    {
        self.id = id
        self.title = title
        self.float_idea = float_idea
        self.user = user
        self.timestamp = timestamp
        self.peopleWholikes = peopleWholikes
        self.comments = comments
        self.likes = likes
        self.category = category
        self.color = colours[category]!
    }
    
    
    let colours = [
        "Charity" : UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0),
        "General" : UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0),
        "Education" : UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0),
        "Health" : UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0),
        "Technology" : UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0),
        "Music" : UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0),
        "Jobs" : UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
    ]
    
}

extension Float {
    func like(){
        let userID = Auth.auth().currentUser!.uid
        var isInList = false
        
                Database.database().reference().child("floats").child(id).child("peopleWholikes").observeSingleEvent(of: .value) { (snapshot) in
            let usersArr = snapshot.value as? NSArray
            for user in usersArr! {
                if (user as? String) == "0" {
                    continue
                }
                else if (user as? String) == userID {
                    isInList = true
                }
            }
                    if(isInList) {
                        let newArr = usersArr?.filter{$0 as? String != userID}
                        snapshot.ref.setValue(newArr)
                        self.addToLikes(hasLiked: true)
                    } else {
                        let newArr = usersArr?.adding(userID)
                        snapshot.ref.setValue(newArr)
                        self.addToLikes(hasLiked: false)
                    }
                }
    }
    
    func addToLikes(hasLiked: Bool) {
        Database.database().reference().child("floats").child(id).child("likes").observeSingleEvent(of: .value) { (snapshot) in
            let likes = snapshot.value as? Int
            if(hasLiked){
               snapshot.ref.setValue(likes! - 1)
            } else {
             snapshot.ref.setValue(likes! + 1)
            }
        }
    }
    
}
