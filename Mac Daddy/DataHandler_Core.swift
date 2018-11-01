//
//  DataHandler_Core.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/18/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation
import Firebase

extension DataHandler {
    

    /////BASIC USER DATA FUNCTIONS////
    
    //Update the user's data in Cloud Firestore
    static func updateUserData(uid: String, values: [String:String]) {
        print("💁‍♀️ Updating user data with values \(values)")
        let userRef = db.collection("users").document(uid)
        updateFirestoreData(ref: userRef, values: values)
    }
    
    
    //Read user data from Cloud Firestore
    static func readUserData(uid: String, key: String) {
        let userRef = db.collection("users").document(uid)
        readFirestoreData(ref: userRef, key: key)
    }
    
    
    ////////BASIC CORE FUNCTIONS/////
    
    
    //Update data at any document in Cloud Firestore
    static func updateFirestoreData(ref: DocumentReference, values: [String:String]) {
        if uid != "" {
            ref.updateData(values) { (error) in
                if let error = error {
                    print("‼️ ERROR: updating data: \(error.localizedDescription)")
                    print("‼️ New values not updating: \(values)")
                } else {
                    print("🔥☝🏼 Updating Firestore Data at document \(ref.documentID)")
                    print("🔥☝🏼 New values: \(values)")
                }
            }
        }
    }
    
    
    //THIS FUNCTION DOESN'T DO ANYTHING, IT'S JUST A TEMPLATE.
    
    //Read data from any reference in Cloud Firestore
    static func readFirestoreData(ref: DocumentReference, key: String){
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                print("🔥 Reading Firestore Data...")
                print("🔥 Data: \(dataDescription)")
                
            } else {
                print("Data does not exist")
            }
        }
    }
    
    
    
}



extension DataHandler {
    
    //Old Code:
    
    //    //Update the user's data in Cloud Firestore
    //    static func updateUserData(uid: String, values: [String:String]) {
    //
    //        if uid != "" {
    //            let ref = db.collection("users").document(uid)
    //            ref.updateData(values) { (error) in
    //                if let error = error {
    //                    print("ERROR: updating user data \(error.localizedDescription)")
    //                } else {
    //                    print("User data updated with reference ID \(ref.documentID)")
    //                }
    //            }
    //        }
    //    }
    //
    //
    //    //Read user data from Cloud Firestore
    //    static func readUserData(uid: String, key: String) {
    //        let userRef = db.collection("users").document(uid)
    //        userRef.getDocument { (document, error) in
    //            if let document = document, document.exists {
    //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    //                print("User data: \(dataDescription)")
    //            } else {
    //                print("User does not exist")
    //            }
    //        }
    //    }
    
    
}
