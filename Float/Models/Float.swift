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
    }
    
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
