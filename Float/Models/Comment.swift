//
//  Comment.swift
//  Float
//
//  Created by Blair Robinson on 13/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import Foundation

class Comment
{
    var floatId: String
    var author: String
    var text: String
    var timestamp: Double
    var profileURL: URL
  
    init(floatId: String, author: String, text: String, timestamp: Double, photoURL: URL){
        self.floatId = floatId
        self.author = author
        self.text = text
        self.timestamp = timestamp
        self.profileURL = photoURL
    }
}

