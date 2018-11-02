//
//  DataHandler_Observers.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/1/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation
import Firebase


extension DataHandler {
    
    func addObserver() {
        print("👂🏻 HomeVC - addObserver: friend Listener fired")
        DataHandler.db.collection("users").document(DataHandler.uid!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error adding friend listener: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
        }

//
//        //First remove the old observer if there was one.
//        friendRef.removeAllObservers()
//        friendRef.observe(.value, with: { snapshot in
//            print("👂🏻 HomeVC - addObserver: friendRef Listener fired")
//            self.syncFriends()
//        })
//
//        //Adding new observer
//        for friend in DataHandler.friendList {
//            let friendConvoRef = friendRef.child(friend.convoID)
//            friendConvoRef.observe(.value, with: { snapshot in
//                print("👂🏻 HomeVC - addObserver: friendConvoRef Listener fired")
//                self.syncConvos()
//            })
//
//        }
    }



    
}
