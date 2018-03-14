//
//  UserData.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/12/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserData {
    
    static var allUsers = [DownloadedUser]()
    
    //Here we're going to write a method exclusively for downloading all the users in Firebase.
    //Is this a good idea? I don't know but let's give it a try.
    //Ok I guess this is a good idea because it worked :)
    
    //Three things we gotta do:
    //1. Download from Firebase like we did in DataHander.checkData
    //2. Reformat this dictionary into an array of users
    //3. Pass it to Matching functions that will choose a friend and initiate a conversation.
    
    static func downloadAllUsers(completed: @escaping ()-> ()) {
        
        //Overwrite previous data.
        allUsers = [DownloadedUser]()
        
        let databaseRef = Database.database().reference()
        if let _ = Auth.auth().currentUser {
            
            databaseRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let usersSnapshot = snapshot.value as? NSDictionary {

                    for (key, value) in usersSnapshot {
                        let dict = value as? [String: Any]
                        var user = DownloadedUser()
                        user.uid = key as! String
                        user.anon = "y"
                        user.convoID = ""
                        user.grade = dict?["Grade"] as? String ?? ""
                        user.macStatus = dict?["Mac Status"] as? String ?? ""
                        user.name = ""
                        user.secondaryA = dict?["SecondaryA"] as? String ?? ""
                        user.weight = 0
                        user.active = dict?["Active"] as? String ?? ""
                    
                        allUsers.append(user)
                    }
                }

                print("Here are the users: \(allUsers)")
             completed()
            }) //End of Firebase snapshot
        }//End of if let user condition
    }//End of downloading users.
    
}//End of user data.


