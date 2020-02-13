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

//From Besst
public typealias failureClosure = (_ error: Error) -> Void
public typealias successVoid = () -> Void
public typealias successAny = (_ response: Any) -> Void
let defaultError = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: ["NSDebugDescription" : "An error occured. Please try again later."])

class NetworkConstants {
    
    // MARK: - Variables
    let realtimeRef = Database.database().reference()
    let firestoreRef = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    // Firebase Tables Names
    private let users = "Users"
    private let userObjects = "UserObjects"
    private let gigObjects = "GigObjects"
    private let friendshipObjects = "FriendshipObjects"
    private let archivedFriendships = "ArchivedFriendships"

    
    // MARK: - Collection paths
    func usersPath() -> CollectionReference {
        return firestoreRef.collection(users)
    }
    
    func userObjectsPath() -> CollectionReference {
        return firestoreRef.collection(userObjects)
    }

    func gigObjectsPath() -> CollectionReference {
        return firestoreRef.collection(gigObjects)
    }
   
    func friendshipObjectsPath() -> CollectionReference {
        return firestoreRef.collection(friendshipObjects)
    }
    
    func archivedFriendshipsPath() -> CollectionReference {
           return firestoreRef.collection(archivedFriendships)
       }
    
    // MARK: - Document paths
    func userObjectPath(userId: String) -> DocumentReference {
        return firestoreRef.collection(userObjects).document(userId)
    }
    
    func gigObjectPath(gigId: String) -> DocumentReference {
         return firestoreRef.collection(gigObjects).document(gigId)
    }
    
    func friendshipObjectPath(convoId: String) -> DocumentReference {
           return firestoreRef.collection(friendshipObjects).document(convoId)
    }
    
    func archivedFriendshipPath(convoId: String) -> DocumentReference {
           return firestoreRef.collection(archivedFriendships).document(convoId)
    }
}


