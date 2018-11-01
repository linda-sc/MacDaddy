//
//  Constants.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/19/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    //Colors
    struct colors {
        static let lavender = UIColor(red: 0.72, green: 0.46, blue: 0.79, alpha: 1.00)
        static let hotPink = UIColor(red: 0.99, green: 0.24, blue: 0.56, alpha: 1.00)
        static let fadedBlue = UIColor(red: 0.54, green: 0.61, blue: 0.99, alpha: 1.00)
        static let neonCarrot = UIColor(red: 0.99, green: 0.60, blue: 0.23, alpha: 1.00)
    }
    
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseConversations = databaseRoot.child("conversations")
    }
}
