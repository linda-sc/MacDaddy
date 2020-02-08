//
//  FriendshipRequests.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/8/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import Firebase

class FriendshipRequests: NSObject {
    
    func upgradeConvoToFriendshipObject(convoId: String) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        let ref = NetworkConstants().friendshipObjectsPath().document(convoId)

        ref.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    print("FriendshipObject exists already. \(String(describing: document.data()))")
                } else {
                    print("FriendshipObjects does not exist. Upgrading now...")
                    
                    var upgradedObject = FriendshipObject()
                    upgradedObject.convoId = convoId
                    
                    self.insertNewFriendshipObjectInFirestore(friendship: upgradedObject)
                    
                }
            }
        }
    }
    
    func insertNewFriendshipObjectInFirestore(friendship: FriendshipObject) {
        if friendship.convoId != nil {
            let ref = NetworkConstants().friendshipObjectPath(convoId: friendship.convoId!)
            guard let friendshipData = friendship.encodeModelObject() else {
                print ("Error encoding FriendshipObject")
                return
            }
            UserRequests().setFirestoreData(ref: ref, values: friendshipData)
        } else {
            print("Friendship convo id is nil. This should not be happening.")
        }
    }
    
    
    //MARK: Functions in progress.
    func friendshipObjectExists(convoId: String) -> Bool {
        return true
    }

    func getFriendshipObjectsInFirestore(_ completion:@escaping(_ querySnapshot:[QueryDocumentSnapshot])->Void){
        let ref = NetworkConstants().friendshipObjectsPath()
        ref.getDocuments { (querySnapshot, err) in
             if let err = err {
                 print("Error getting friendshipObjects: \(err)")
             } else {
                 if let documents = querySnapshot?.documents{
                     completion(documents)
                 }
            }
        }
    }
    
    func loadFriendshipObjects() {
        getFriendshipObjectsInFirestore { (documents) in
            for document in documents{
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    
}
