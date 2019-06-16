//
//  FirebaseConstants.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/9/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// This class makes it easier to reference the database.
//////////////////////////////////////////////////
//////////////////////////////////////////////////

class NetworkConstants {
    
    // MARK: - Variables
    let realtimeRef = Database.database().reference()
    let firestoreRef = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    // Firebase Tables Names
    private let users = "Users"
    private let userObjects = "UserObjects"
    
    
    // MARK: - Functions
    func usersPath() -> CollectionReference {
        return firestoreRef.collection(users)
    }
    
    func userObjectsPath() -> CollectionReference {
        return firestoreRef.collection(userObjects)
    }
    
    func userObjectPath(userId: String) -> DocumentReference {
        return firestoreRef.collection(userObjects).document(userId)
    }
}


