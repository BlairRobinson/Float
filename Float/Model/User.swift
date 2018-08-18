//
//  User.swift
//  Float
//
//  Created by Blair Robinson on 07/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import Foundation
import UIKit

class User
{
    var uid: String
    var email: String
    var profileURL: URL
    var fullName: String
    
    init(uid: String, email: String, profileURL: URL, fullName: String) {
        self.email = email
        self.uid = uid
        self.profileURL = profileURL
        self.fullName = fullName
    }
}
