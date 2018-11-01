//
//  DataHandler_FriendFunctions.swift
//  Mac Daddy
//
//  Created by Linda Chen on 10/30/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation
import Firebase

extension DataHandler {
    
    //Download the data from Firebase:
    static func downloadFriends(completed: @escaping ()-> ()) {
        
        if let user = Auth.auth().currentUser {
            
            DataHandler.user = user
            DataHandler.uid = user.uid
            
            db.collection("users").document(uid!).getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    print("🔥👯‍♀️ Downloading Friend Data only...")
                    let snapshot = document.data()
                    
                    //Download friends.
                    if let friends = snapshot?["friends"] as! NSDictionary? {
                        self.friendList = self.friendDictionaryToList(friends: friends as! [String : [String : String]])
                        print("👯‍♀️ downloadFriends: Friends exist:")
                        print(self.friends)
                        print("👯‍♀️ downloadFriends: Friends exist:")
                        completed()
                    } else {
                        self.friends = NSDictionary()
                         print("👯‍♀️ downloadFriends: Friends dont exist")
                        completed()
                    }
                    
                } else {
                    print("👯‍♀️ downloadFriends: Data does not exist")
                    completed()
                }
                
            } //End of Firestore snapshot
        }//End of if let user condition
    }//End of downloadFriends.
    
    
    //Converts a list of friend objects into a dictionary for Firebase
    static func friendListToDictionary(friends:[Friend]) -> [String:[String:String]] {
        var friendDict = [String:[String:String]]()
        for friend in friends {
            friendDict[friend.uid] = ["ConvoID": friend.convoID ,
                                      "Name": friend.name,
                                      "Anon": friend.anon,
                                      "MacStatus": friend.macStatus,
                                      "Grade": friend.grade,
                                      "Active": friend.active,
                                      "LastActive": friend.lastActive,
            ]
        }
        return friendDict
    }
    
    
    //Converts a dictionary back into a list of friend structs for easy use locally.
    static func friendDictionaryToList(friends:[String:[String:String]]) -> [Friend] {
        var friendList = [Friend]()
        for friend in friends {
            var friendStruct = Friend()
            let data = friend.value
            friendStruct.uid = friend.key
            friendStruct.name = data["Name"] ?? ""
            friendStruct.convoID = data["ConvoID"] ?? ""
            friendStruct.anon = data["Anon"] ?? ""
            friendStruct.macStatus = data["MacStatus"] ?? ""
            friendStruct.grade = data["Grade"] ?? ""
            friendStruct.active = data["Active"] ?? ""
            friendStruct.lastActive = data["LastActive"] ?? ""
            
            friendList.append(friendStruct)
        }
        return friendList
    }
    
    
    
    //Update your own friend list
    static func updateFriendList(friends:[String:[String:String]]) {
        print("Check to this if this works 🌚")
        let friendListRef = db.collection("users").document(uid!).collection("friends")
        for friend in friends {
            let friendRef = friendListRef.document(friend.key)
            updateFirestoreData(ref: friendRef, values: friend.value)
        }
    }
    
    //Update when you go online
    static func updateActivityinFriendsLists(active: String) {
        print("🌟 Updating activity in friends lists.")
        for friend in friendList {
            
            let friendsOfFriendsRef = db.collection("users").document(friend.uid).collection("friends")
            let selfInFriendsListRef = friendsOfFriendsRef.document(uid!)
            
            updateFirestoreData(ref: selfInFriendsListRef, values: ["Active" : active])
        }
    }
    
    //Whether you're unmatching someone or just taking them off of your friend list, you delete the data from both your friend list and theirs.
    //Note, this ONLY removes them in Firebase, NOT LOCALLY. We rely on the friend observer to delete the local data.
    
    static func deleteFriend(friend:Friend, anon: Bool) {
        print("☄️ Deleting friend: \(friend.uid), Anon = \(anon)")
        let selfRef = db.collection("users").document(self.uid!)
        let friendRef = db.collection("users").document(friend.uid)
        let selfInFriendsOfFriendsRef = friendRef.collection("friends").document(self.uid!)
        let friendInFriendsListRef = selfRef.collection("friends").document(friend.uid)
        
        let convoRef = rtdb.child("conversations").child(friend.convoID)
        
        //Take them off of your friend list
        friendInFriendsListRef.delete()
        
        //Take yourself off of their friend list
        selfInFriendsOfFriendsRef.delete()
        
        //Delete your conversation.
        convoRef.removeValue()
        
        if anon {
            if (friend.uid == currentMatchID) {
                //If its an anonymous conversation you initiated:
                selfRef.updateData(["PrimaryA" : "y"])
                friendRef.updateData(["SecondaryA": "y"])
                
            } else {
                //If its an anonymous conversation someone else intiated:
                selfRef.updateData(["SecondaryA" : "y"])
                friendRef.updateData(["PrimaryA": "y"])
            }
        }
    }
    
    //Update friend's data in Firebase.
    static func updateFriendData(friend: Friend, newMatch: Bool) {
        print("🙌🏻 Updating friend data for friend \(friend.uid).")
        //Take the friend's user id and add yourself to their friend list as an anonymous friend.
        //The only thing you have to change is their secondary availibility.
        //Doesn't override old values!
        
        let selfRef = db.collection("users").document(self.uid!)
        let friendRef = db.collection("users").document(friend.uid)
        let selfInFriendsOfFriendsRef = friendRef.collection("friends").document(self.uid!)
        let friendInFriendsListRef = selfRef.collection("friends").document(friend.uid)
        
        //Update values:
        var myInfo = [String:Any]()
        var friendInfo = [String:Any]()
        
        //If it's a new match, update with anonymous info.
        if newMatch {
            
            //Change availability:
            DataHandler.updateFirestoreData(ref: selfRef, values: ["PrimaryA" : "n"])
            DataHandler.updateFirestoreData(ref: friendRef, values: ["SecondaryA" : "n"])
            
            //Add yourself to their friend list and make sure you are anonymous.
            let anonName = "Anonymous " + Matching.fakeNames[Int(arc4random_uniform(UInt32(Matching.fakeNames.count)))]
            
            myInfo = ["ConvoID": friend.convoID ,
                      "Name": anonName,
                      "Anon": "y",
                      "MacStatus": self.macStatus,
                      "Grade": self.grade,
            ]
            
            friendInfo = ["ConvoID": friend.convoID ,
                          "Name": friend.name,
                          "Anon": "y",
                          "MacStatus": friend.macStatus,
                          "Grade": friend.grade,
            ]
            
        } else {
            
            //Otherwise add yourself as a normal friend, or update your information.
            friendInfo = ["ConvoID": friend.convoID ,
                          "Name": friend.name,
                          "Anon": "n",
                          "MacStatus": friend.macStatus,
                          "Grade": friend.grade,
            ]
            
            
            myInfo = ["ConvoID": friend.convoID ,
                      "Name": DataHandler.name,
                      "Anon": "n",
                      "MacStatus": self.macStatus,
                      "Grade": self.grade,
            ]
            
            //Change availability:
            DataHandler.updateFirestoreData(ref: selfRef, values: ["PrimaryA" : "y"])
            DataHandler.updateFirestoreData(ref: friendRef, values: ["SecondaryA" : "y"])
            
        }
        
        //Add yourself to their friend list, and vice versa.
        
        DataHandler.updateFirestoreData(ref: selfInFriendsOfFriendsRef, values: myInfo as! [String : String])
        DataHandler.updateFirestoreData(ref: friendInFriendsListRef, values: friendInfo as! [String : String])
        
    }
    
    
    
    static func orderFriends() {
        //We're just gonna order the friends here somehow.
        //This function will be called in sync friends.
        var orderedFriendList = [Friend]()
        
        //For now let's just put anonymous friends first.
        for friend in self.friendList {
            if friend.anon == "y" {
                orderedFriendList.append(friend)
            }
        }
        
        for friend in self.friendList {
            if friend.anon == "n" {
                orderedFriendList.append(friend)
            }
        }
        
        self.friendList = orderedFriendList
        
    }
    
}
