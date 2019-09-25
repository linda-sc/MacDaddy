//
//  UserData.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/12/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class UserData {
    
    static var allUsers = [Friend]()
    static var allUserObjects = [UserObject]()
    static var blockedUsers = [Friend]()
    
    //Here we're going to write a method exclusively for downloading all the users in Firebase.
    //Is this a good idea? I don't know but let's give it a try.
    //Ok I guess this is a good idea because it worked :)
    
    //Three things we gotta do:
    //1. Download from Firebase like we did in DataHander.checkData
    //2. Reformat this dictionary into an array of users
    //3. Pass it to Matching functions that will choose a friend and initiate a conversation.

    
    static func downloadAllUserObjects(completed: @escaping ()-> ()) {
        print("🦋 Downloading all UserObjects...")
        
        //Overwrite previous data.
        allUserObjects = [UserObject]()
        
        
        DataHandler.db.collection("UserObjects").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("💥 Error getting users: \(err)")
            } else {
                //First download all the blocked users
                downloadBlockedUsers {
                    //Then don't download any new users that have been blocked
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data() as NSDictionary
                        
                        if (!JSONSerialization.isValidJSONObject(data)) {
                            print("is not a valid json object")
                            return
                        }
                        
                        let userObject = decode(json: data, obj: UserObject.self)
                        
                        //Immediately convert the coordinates into a location object.
                        if let latitude = userObject?.latitude, let longitude = userObject?.longitude {
                            userObject?.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
                        }
                        
                        var blocked = false
                        for blockedUser in blockedUsers {
                            if blockedUser.uid == document.documentID {
                                blocked = true
                            }
                        }
                        if !blocked {
                            allUserObjects.append(userObject!)
                        }
                        
                    }//End of querySnapshot
                    print("🦋 Downloaded all UserObjects: \(allUserObjects)")
                    completed()
                }//End of blockedUsers closure
            }
        }
        
    }//End of downloading user objects.
    
    
    static func downloadAllUsers(completed: @escaping ()-> ()) {
        print("🦋 Downloading all users...")
        
        //Overwrite previous data.
        allUsers = [Friend]()
        
        
        DataHandler.db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("💥 Error getting users: \(err)")
            } else {
                //First download all the blocked users
                downloadBlockedUsers {
                    //Then don't download any new users that have been blocked
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let userObject = userDictionaryToList(uid: document.documentID, data: document.data() as! [String : String])
                    
                        var blocked = false
                        for blockedUser in blockedUsers {
                            if blockedUser.uid == document.documentID {
                                blocked = true
                            }
                        }
                        
                        if !blocked {
                            allUsers.append(userObject)
                        }
                        
                    }//End of querySnapshot
                    print("🦋 Downloaded all users: \(allUsers)")
                    completed()
                }//End of blockedUsers closure
            }
        }
        
    }//End of downloading users.
    
    static func downloadBlockedUsers(completed: @escaping ()-> ()) {
        print("😳 Downloading blocked users...")
        
        //Overwrite previous data.
        blockedUsers = [Friend]()
        if let uid = Auth.auth().currentUser?.uid {
            DataHandler.db.collection("users").document(uid).collection("blocked").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("💥 Error getting blocked users: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let userObject = userDictionaryToList(uid: document.documentID, data: document.data() as! [String : String])
                        blockedUsers.append(userObject)
                    }
                    print("😳 Downloaded all blocked: \(blockedUsers)")
                    completed()
                }
            }
            
        } //End of if let uid condition
    }//End of downloading users.
    

    
    ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
    //Converts a dictionary back into a list of user structs for easy use locally.
    static func userDictionaryToList(uid: String, data: [String:String]) -> Friend {
        var friendStruct = Friend()
        
        friendStruct.uid = uid
        //Skip 1: PrimaryA
        friendStruct.secondaryA = data["2: SecondaryA"] ?? ""
        friendStruct.organization = data["3: Organization"] ?? ""
        //Skip 4: Email
        friendStruct.name = data["5: Name"] ?? ""
        friendStruct.macStatus = data["6: MacStatus"] ?? ""
        friendStruct.convoID = data["7: ConvoID"] ?? ""
        friendStruct.active = data["8: Active"] ?? ""
        
        friendStruct.anon = data["Anon"] ?? ""
        friendStruct.grade = data["9: Grade"] ?? ""
        friendStruct.lastActive = data["LastActive"] ?? "" 
        
        return friendStruct
    }
}//End of user data.


