//
//  UserData.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/12/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase

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
        print("🦋 Downloading all users...")
        
        //Overwrite previous data.
        allUsers = [DownloadedUser]()
        
        
        DataHandler.db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("💥 Error getting users: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let userObject = userDictionaryToList(uid: document.documentID, data: document.data() as! [String : String])
                    allUsers.append(userObject)
                }
                print("🦋 Downloaded all users: \(allUsers)")
            }
        }
        
    }//End of downloading users.
    

    //Converts a dictionary back into a list of user structs for easy use locally.
    static func userDictionaryToList(uid: String, data: [String:String]) -> DownloadedUser {
        var userStruct = DownloadedUser()
        var friendStruct = Friend()
        
        friendStruct.uid = uid
        friendStruct.name = data["Name"] ?? ""
        friendStruct.convoID = data["ConvoID"] ?? ""
        friendStruct.anon = data["Anon"] ?? ""
        friendStruct.macStatus = data["MacStatus"] ?? ""
        friendStruct.grade = data["Grade"] ?? ""
        friendStruct.active = data["Active"] ?? ""
        friendStruct.lastActive = data["LastActive"] ?? ""
        
        userStruct.friendInfo = friendStruct
        userStruct.secondaryA = data["SecondaryA"] ?? ""
    
        return userStruct
    }
}//End of user data.


