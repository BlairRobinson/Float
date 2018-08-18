//
//  UserService.swift
//  Float
//
//  Created by Blair Robinson on 23/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProf: User?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile: User?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        userRef.observe(.value) { (snapshot) in
            var userProfile:User?
            if let dict = snapshot.value as? [String:Any], let email = dict["email"] as? String,
                let profileURL = dict["photoURL"] as? String, let url = URL(string: profileURL),
                let fullName = dict["name"] as? String{
                userProfile = User(uid: snapshot.key, email: email, profileURL: url, fullName: fullName)
            }
            completion(userProfile)
        }
    }
}
