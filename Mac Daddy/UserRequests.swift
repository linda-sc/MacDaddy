//
//  UserRequests.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/9/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import Firebase

// Closures?
// https://medium.com/the-andela-way/closures-in-swift-8aef8abc9474

// Closures can capture and store reference to any constants and variables
// from the context in which they are defined.
// This is known as closing over them, hence the name closures. 💡
// Frequent uses:
// 1. Animations
// 2. Fetching data
// 3. Passing data between ViewControllers

// Closures are essentially "headless functions."
// Steps to turning a function into a closure:
// 1. Add "in" before the first curly brace
// 2. Remove curly braces
// 3. Remove "func" and function title
// 4. Surround everything with curly braces
// 5. Set the entire expression to a variable: var closure = {() -> Int in return 1}

class UserRequests: NSObject {
    
    //////////////////////////////////////////////////
    // MARK: 1. Inserting data anywhere in Firestore
    //////////////////////////////////////////////////
    
    //Update data at any document in Cloud Firestore
    func updateFirestoreData(ref: DocumentReference, values: RawJSON) {
        if Auth.auth().currentUser?.uid != "" {
            ref.updateData(values) { (error) in
                if let error = error {
                    print("‼️ ERROR: updating data: \(error.localizedDescription)")
                    print("‼️ New values not updating: \(values)")
                } else {
                    print("🔥☝🏼 Updating Firestore Data at document \(ref.documentID)")
                    print("     New values: \(values)")
                }
            }
        }
    }
    
    //Create data at any document in Cloud Firestore
    func setFirestoreData(ref: DocumentReference, values: RawJSON) {
        if Auth.auth().currentUser?.uid != "" {
            ref.setData(values, merge: true) { (error) in
                if let error = error {
                    print("‼️ ERROR: setting new data: \(error.localizedDescription)")
                    print("‼️ New data not uploading: \(values)")
                } else {
                    print("🔥☝🏼 Creating Firestore Data at document \(ref.documentID)")
                    print("      New values: \(values)")
                }
            }
        }
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: 2. Insert a new user object into firestore.
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    func insertUserInFirestore(userObject: UserObject) {
        let ref = NetworkConstants().userObjectPath(userId: userObject.uid!)
        guard let userData = userObject.encodeModelObject() else {
            print ("Error encoding UserObject")
            return
        }
        self.setFirestoreData(ref: ref, values: userData)
    }
    
    func updateUserInFirestore(userObject: UserObject) {
        let ref = NetworkConstants().userObjectPath(userId: userObject.uid!)
        guard let userData = userObject.encodeModelObject() else {
            print ("Error encoding UserObject")
            return
        }
        self.updateFirestoreData(ref: ref, values: userData)
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: 3. Download the existing current user object from firestore.
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    func downloadCurrentUserObjectFromFirestore(userId: String) {
        let ref = NetworkConstants().userObjectPath(userId: userId)
        ref.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    //If the object is already there, then download it
                    print("Document data: \(document.data())")
                    print("UserObject exists")
                    if document.data() != nil {
                        let currentUser = decode(json: document.data(), obj: UserObject.self)
                        UserManager.shared.currentUser = currentUser
                        print("Successfully downloaded current user object.")
                    } else {
                        print("UserObject data is nil")
                    }
                } else {
                    //If the user has just logged into the new version for the first time, then import their info from DataHandler and make them a new UserObject.
                    print("UserObject does not exist. Creating UserObject via DataHandler.")
                    UserManager.shared.importCurrentUserFromDataHandler()
                    UserRequests().insertUserInFirestore(userObject: UserManager.shared.currentUser!)
                    print("Successfully inserted UserObject into Firestore.")

                }
            }
        }
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: 4. Download any user object from firestore.
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    func downloadUserDocument(userId: String, success: @escaping successAny, failure: @escaping failureClosure) {
        if userId != "" {
            let ref = NetworkConstants().userObjectPath(userId: userId)
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Fetching user document data: \(dataDescription)")
                    if let userData = document.data() {
                        success(userData)
                        print("Successfully downloaded user document")
                    } else {
                        print("User document data is nil")
                        failure(defaultError)
                    }
                } else {
                    print("User document does not exist")
                    failure(defaultError)
                }
            }
        }
    }
    
    //Pairs with previous method
    func fetchUserObject(userID: String, success: successAny? = nil, failure: failureClosure? = nil) {
        self.downloadUserDocument(userId: userID, success: { (userData) in
            if let userObject = decode(json: userData, obj: UserObject.self) {
                success?(userObject)
                print("Successfully fetched user object")
            } else {
                print("User document data is corrupted")
                failure?(defaultError)
            }
        }) { (error) in
            print("User not found")
            failure?(error)
        }
    }
}

