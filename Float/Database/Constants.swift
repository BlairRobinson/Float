//
//  Constants.swift
//  Float
//
//  Created by Blair Robinson on 24/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import Foundation
import Firebase

struct Connections {
    
    static var storageRef: StorageReference {
        return Storage.storage().reference().child("user/" + (Auth.auth().currentUser?.uid)!)
    }
    
    static var databaseRefUsers: DatabaseReference {
        return Database.database().reference().child("users/profile/" + (Auth.auth().currentUser?.uid)!)
    }
    
    static var databaseRefFloats: DatabaseReference {
        return Database.database().reference().child("floats")
    }
    
    static var databaseRefComments: DatabaseReference {
        return Database.database().reference().child("Comments")
    }
    
}
