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
        print("🔥👯‍♀️ Downloading Friend Data only...")
        
        if let user = Auth.auth().currentUser {
            
            DataHandler.user = user
            DataHandler.uid = user.uid
            
            db.collection("users").document(uid!).collection("friends").getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("‼️ Error getting friends: \(err)")
                } else {
                    print("     👯‍♀️ downloadFriends: Friends exist:")
                    var newFriendList = [Friend]()
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        
                        let friendObject = friendDictionaryToObject(uid: document.documentID, data: document.data() as! [String : String])
                        newFriendList.append(friendObject)
   
                    }
                    self.friendList = newFriendList
                    //print(self.friendList)
                    completed()
                }
                
            } //End of Firestore snapshot
        } else {
            print("     👯‍♀️ downloadFriends: No current user")
            completed()
        }//End of if let user condition
    }//End of downloadFriends.
    

    ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
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
    
    
    ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
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
    
    
    ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
    //Converts a dictionary back into a friend struct for easy use locally.
    static func friendDictionaryToObject(uid: String, data: [String:String]) -> Friend {
        var friendStruct = Friend()
        friendStruct.uid = uid
        friendStruct.name = data["Name"] ?? ""
        friendStruct.convoID = data["ConvoID"] ?? ""
        friendStruct.anon = data["Anon"] ?? ""
        friendStruct.macStatus = data["MacStatus"] ?? ""
        friendStruct.grade = data["Grade"] ?? ""
        friendStruct.active = data["Active"] ?? ""
        friendStruct.lastActive = data["LastActive"] ?? ""

        return friendStruct
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
        print("🌟 NOT Updating activity in friends lists.")
//        for friend in friendList {
//
//            let friendsOfFriendsRef = db.collection("users").document(friend.uid).collection("friends")
//            let selfInFriendsListRef = friendsOfFriendsRef.document(uid!)
//
//            updateFirestoreData(ref: selfInFriendsListRef, values: ["Active" : active])
//        }
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
        let archivedConvoRef = rtdb.child("archives").child(friend.convoID)
        
        //Take them off of your friend list
        friendInFriendsListRef.delete()
        
        //Take yourself off of their friend list
        selfInFriendsOfFriendsRef.delete()
        
        //Delete your conversation.
        //Rewrite this function so that you're moving the conversation to a new branch instead of deleting it.
        //First, take a snapshot of the current conversation in RTDB:
        convoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get convo value
            let convoData = snapshot.value as? NSDictionary
            archivedConvoRef.setValue(convoData) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Conversation could not be archived: \(error).")
                } else {
                    print("Conversation archived successfully!")
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        convoRef.removeValue()
        
        if anon {
            print("🌹 Deleting anon friend")
            if (friend.uid == currentMatchID) {
                print("🌹 Deleting my match")
                //If its an anonymous conversation you initiated:
                selfRef.updateData(["1: PrimaryA" : "1"])
                friendRef.updateData(["2: SecondaryA": "1"])
                
            } else {
                print("🌹 Deleting someone who matched with me")
                //If its an anonymous conversation someone else intiated:
                selfRef.updateData(["2: SecondaryA" : "1"])
                friendRef.updateData(["1: PrimaryA": "1"])
            }
        }
    }
    
    
    static func blockFriend(friend: Friend, report: String) {
        print("☄️ Blocking friend: \(friend.uid)")
        let selfRef = db.collection("users").document(self.uid!)
        let friendInFriendListRef = selfRef.collection("friends").document(friend.uid)
        let blockedListRef = selfRef.collection("blocked").document(friend.uid)
        
        //Read from Firebase
        friendInFriendListRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //Perform neccessary conversions
                let friend = friendDictionaryToObject(uid: document.documentID, data: document.data() as! [String : String])

                let friendDict = ["ConvoID": friend.convoID ,
                                  "Name": friend.name,
                                  "Anon": friend.anon,
                                  "MacStatus": friend.macStatus,
                                  "Grade": friend.grade,
                                  "Active": friend.active,
                                  "LastActive": friend.lastActive,
                                  //Just add in the report here cuz it might help
                                  "Report": report
                 ]
                
                //Immediately write back to Firebase
                DataHandler.setFirestoreData(ref: blockedListRef, values: friendDict)
                self.sendReport(friend: friend, report: report)
                
                //Only remove them as a friend if you successfully blocked them and sent a report
                let isAnon = (friend.anon == "1")
                deleteFriend(friend: friend, anon: isAnon)

            } else {
                print("Friend does not exist")
            }
        }
    }
    
    static func sendReport(friend: Friend, report: String) {
        print("👮🏾 Sending report on: \(friend.uid)")
    
        //Generate a data and time for the report
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let convertedDate = formatter.string(from: currentDate)
        
        //Push the report data to the reports collection
        //Sorted by date and time:
        let reportRef = db.collection("reports").document(convertedDate)
        
        let reportData = ["ConvoID": friend.convoID ,
                          "Name": friend.name,
                          "Anon": friend.anon,
                          "MacStatus": friend.macStatus,
                          "Grade": friend.grade,
                          "Active": friend.active,
                          "LastActive": friend.lastActive,
                          //Just add in the report here cuz it might help
                            "Report": report
        ]
        
        DataHandler.setFirestoreData(ref: reportRef, values: reportData)
        
    }
    
    static func freeUpAvailability(friend: Friend){
        print("💕 Matched with: \(friend.uid)!")
        let selfRef = db.collection("users").document(self.uid!)
        let friendRef = db.collection("users").document(friend.uid)
    
        if self.currentMatchID == friend.uid {
            print("🌹 Saving my match")
            //If its an anonymous conversation you initiated:
            selfRef.updateData(["1: PrimaryA" : "1"])
            friendRef.updateData(["2: SecondaryA": "1"])
                
        } else {
            print("🌹 Saving someone who matched with me")
            //If its an anonymous conversation someone else intiated:
            selfRef.updateData(["2: SecondaryA" : "1"])
            friendRef.updateData(["1: PrimaryA": "1"])
            
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
            DataHandler.updateFirestoreData(ref: selfRef, values: ["1: PrimaryA" : "0"])
            DataHandler.updateFirestoreData(ref: friendRef, values: ["2: SecondaryA" : "0"])
            
            
            ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
            //Add yourself to their friend list and make sure you are anonymous.
            let anonName = "Anonymous " + Constants.fakeNames[Int(arc4random_uniform(UInt32(Constants.fakeNames.count)))]
            
            myInfo = ["ConvoID": friend.convoID ,
                      "Name": anonName,
                      "Anon": "1",
                      "MacStatus": self.macStatus,
                      "Grade": self.grade,
            ]
            
            friendInfo = ["ConvoID": friend.convoID ,
                          "Name": friend.name,
                          "Anon": "1",
                          "MacStatus": friend.macStatus,
                          "Grade": friend.grade,
            ]
            
        } else {
            
            ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
            //Otherwise add yourself as a normal friend, or update your information.
            friendInfo = ["3: Organization": friend.organization,
                          "4: Email": friend.email,
                          "5: Name": friend.name,
                          "6: MacStatus": friend.macStatus,
                          "7: ConvoID": friend.convoID ,
                          "Anon": "0",
                          "9: Grade": friend.grade,
            ]
            
            
            myInfo = ["3: Organization": DataHandler.organization,
                      "4: Email": user?.email,
                      "5: Name": DataHandler.name,
                      "6: MacStatus": self.macStatus,
                      "7: ConvoID": friend.convoID,
                      "Anon": "0",
                      "9: Grade": self.grade,
            ]
            
            //Change availability:
            DataHandler.updateFirestoreData(ref: selfRef, values: ["1: PrimaryA" : "1"])
            DataHandler.updateFirestoreData(ref: friendRef, values: ["2: SecondaryA" : "1"])
            
        }
        
        //Add yourself to their friend list, and vice versa.
        DataHandler.setFirestoreData(ref: selfInFriendsOfFriendsRef, values: myInfo as! [String : String])
        DataHandler.setFirestoreData(ref: friendInFriendsListRef, values: friendInfo as! [String : String])
        
    }
    
    
    static func orderFriends() {
        //We're just gonna order the friends here somehow.
        //This function will be called in sync friends.
        var orderedFriendList = [Friend]()
        
        //For now let's just put anonymous friends first.
        for friend in self.friendList {
            if friend.anon == "1" {
                orderedFriendList.append(friend)
            }
        }
        
        for friend in self.friendList {
            if friend.anon == "0" {
                orderedFriendList.append(friend)
            }
        }
        
        self.friendList = orderedFriendList
        
    }
    
}
