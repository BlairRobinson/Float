//
//  Message.swift
//  Float
//
//  Created by Blair Robinson on 29/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class Message {
    
    var fromId: String
    var text: String
    var toId: String
    var timeStamp: Int
    
    init(fromId: String, text: String, toId: String, timeStamp: Int) {
        self.fromId = fromId
        self.text = text
        self.toId = toId
        self.timeStamp = timeStamp
    }
    
    func chatPartnerId() -> String? {
        
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        } else {
            return fromId
        }
    }
}
