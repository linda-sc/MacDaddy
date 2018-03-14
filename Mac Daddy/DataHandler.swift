//
//  DataHandler.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//
//  DataHandler syncs data between Firebase, local class variables, and user defaults.

import Foundation
import Firebase

class DataHandler {
    
    static var user = Auth.auth().currentUser
    static var uid = Auth.auth().currentUser?.uid
    static var databaseRef = Database.database().reference()
    static var storageRef = Storage.storage().reference()

    static var nameExists:Bool = false
    static var picExists:Bool = false
    static var gradeExists:Bool = false
    static var interestsExist:Bool = false
    
    static var name = ""
    static var picURL = ""
    static var grade = ""
    static var macStatus = ""
    
    static var interests = NSDictionary()
    static var friends = NSDictionary()
    static var friendList = [Friend]()
    static var currentMatchID = ""
    static var convos = [Convo]()

    
    //Saves the DataHandler class data to user defaults
    static func saveDefaults(){
        UserDefaults.standard.set(self.name, forKey: "Name")
        UserDefaults.standard.set(self.picURL, forKey: "PicURL")
        UserDefaults.standard.set(self.grade, forKey: "Grade")
        UserDefaults.standard.set(self.macStatus, forKey: "MacStatus")
        UserDefaults.standard.set(self.interests, forKey: "Interests")
        UserDefaults.standard.set(self.friends, forKey: "Friends")
        UserDefaults.standard.set(self.currentMatchID, forKey: "CurrentMatchID")
    }
    
    //Clears the user defaults.
    static func clearDefaults(){
        self.name = ""
        self.picURL = ""
        self.grade = ""
        self.macStatus = ""
        
        self.interests = NSDictionary()
        self.friends = NSDictionary()
        self.currentMatchID = ""
        
        UserDefaults.standard.set("", forKey: "Name")
        UserDefaults.standard.set("", forKey: "PicURL")
        UserDefaults.standard.set("", forKey: "Grade")
        UserDefaults.standard.set("", forKey: "MacStatus")
        UserDefaults.standard.set(NSDictionary(), forKey: "Interests")
        UserDefaults.standard.set(NSDictionary(), forKey: "Friends")
        UserDefaults.standard.set("", forKey: "CurrentMatchID")
    }
    
    //Fetches the class data from the user defaults.
    static func getDefaults() {
        self.name = UserDefaults.standard.string(forKey: "Name") ?? ""
        self.picURL = UserDefaults.standard.string(forKey: "PicURL") ?? ""
        self.grade = UserDefaults.standard.string(forKey: "Grade") ?? ""
        self.macStatus = UserDefaults.standard.string(forKey: "MacStatus") ?? ""
        self.interests = UserDefaults.standard.dictionary(forKey: "Interests")! as NSDictionary
        self.friends = UserDefaults.standard.dictionary(forKey: "Friends")! as NSDictionary
        self.currentMatchID = UserDefaults.standard.string(forKey: "CurrentMatchID") ?? ""
        
        print("Fetching user defaults: \(UserDefaults.standard.string(forKey: "MacStatus") ?? "No Mac Status")")
    }
    
    static func clearDataHandler() {
        user = nil
        uid = nil
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        nameExists = false
        picExists = false
        gradeExists = false
        interestsExist = false
        
        name = ""
        picURL = ""
        grade = ""
        macStatus = ""
        
        interests = NSDictionary()
        friends = NSDictionary()
        friendList = [Friend]()
        currentMatchID = ""
        convos = [Convo]()
    }
    
    
    //Update the user's email in Firebase.
    static func updateEmail(email:String) {
        updateUserData(uid: uid!, values: ["Email": email])
    }
    
    //Update the user's name in Firebase.
    static func updateName(name:String) {
        updateUserData(uid: uid!, values: ["Name": name])
    }
    
    //Update the user's Mac Status in Firebase.
    static func updateMacStatus(status:String) {
        updateUserData(uid: uid!, values: ["Mac Status": status])
    }
    
    //Update the user's availibility as an initiator in Firebase.
    static func updatePrimaryAvailibility(primaryAvailibility:String) {
        updateUserData(uid: uid!, values: ["PrimaryA": primaryAvailibility])
    }
    
    //Update the user's availibility as a reciever in Firebase.
    static func updateSecondaryAvailibility(secondaryAvailibility:String) {
        updateUserData(uid: uid!, values: ["SecondaryA": secondaryAvailibility])
    }
    
    //Update the user's current match in Firebase and in DataHandler.
    static func updateCurrentMatchID(currentMatchID:String) {
        updateUserData(uid: uid!, values: ["Current Match ID": currentMatchID])
        self.currentMatchID = currentMatchID
    }
    
    //Update the user's status variables.
    static func updateStatusVariables(active: String) {
        //let currentDateTime = Date().timeIntervalSinceReferenceDate
        
        if let uid = uid {
            updateUserData(uid: uid, values: ["Active": active])
            updateStatusInFriendsLists(active: active)
        }
    }
    
    //Update status variables in friends' lists.
    static func updateStatusInFriendsLists(active: String) {
        for friend in friendList {
            let friendsListRef = databaseRef.child("users").child(friend.uid).child("Friends")
            let friendsListSelfRef = friendsListRef.child(uid!)
            friendsListSelfRef.updateChildValues(["Active" : active])
        }
        
    }
    
    //Update the user's friends in Firebase.
    static func updateFriends(uid: String, friends:[String:[String:String]]) {
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let usersReference = ref.child("users").child(uid).child("Friends")
        for friend in friends {
            usersReference.updateChildValues(friend.value)
        }
    }
    
    //Update the user's interests in Firebase.
    static func updateInterests(uid: String, interests:[String:String]) {
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let usersReference = ref.child("users").child(uid).child("Interests")
        usersReference.updateChildValues(interests)
    }
    
    //Update the user's data in Firebase.
    static func updateUserData(uid: String, values: [String:String]) {
        //Doesn't override old values!
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        //Update values:
        usersReference.updateChildValues(values)
    }
    
    //Update friend's data in Firebase.
    static func updateFriendData(friend:Friend, newMatch: Bool) {
        //Take the friend's user id and add yourself to their friend list as an anonymous friend.
        //The only thing you have to change is their secondary availibility.
        //Doesn't override old values!
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let selfRef = ref.child("users").child(self.uid!)
        let matchRef = ref.child("users").child(friend.uid)
        let friendSelfRef = ref.child("users").child(friend.uid).child("Friends").child(self.uid!)
        let selfFriendRef = ref.child("users").child(self.uid!).child("Friends").child(friend.uid)
        
        //Update values:
        var myInfo = [String:Any]()
        var friendInfo = [String:Any]()
        
        //If it's a new match, update with anonymous info.
        if newMatch {
            
            //Change availability:
            matchRef.updateChildValues(["SecondaryA" : "n"])
            selfRef.updateChildValues(["PrimaryA" : "n"])
            
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
            matchRef.updateChildValues(["SecondaryA" : "y"])
            selfRef.updateChildValues(["PrimaryA" : "y"])
        }
        
        //Add yourself to their friend list, and vice versa.
        friendSelfRef.updateChildValues(myInfo)
        selfFriendRef.updateChildValues(friendInfo)

    }

    
    //Whether you're unmatching someone or just taking them off of your friend list, you delete the data from both your friend list and theirs.
    //Note, this ONLY removes them in Firebase, NOT LOCALLY. Maybe you wanna fix that.
    
    static func deleteFriend(friend:Friend, anon: Bool) {
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let selfRef = ref.child("users").child(self.uid!)
        let friendRef = ref.child("users").child(friend.uid)
        let friendSelfRef = ref.child("users").child(friend.uid).child("Friends").child(self.uid!)
        let convoRef = ref.child("conversations").child(friend.convoID)
        
        //Take them off of your friend list
        selfRef.child("Friends").child(friend.uid).removeValue()
        //Take yourself off of their friend list
        friendSelfRef.removeValue()
        //Delete your conversation.
        convoRef.removeValue()
        
        if anon {
            //There's a slight problem here but we'll deal with it later.
            selfRef.updateChildValues(["PrimaryA": "y"])
            friendRef.updateChildValues(["SecondaryA" : "y"])
        }
    }
    
    //For testing purposes only:
    static func deleteAllFriends(uid:String) {
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let selfFriendRef = ref.child("users").child(uid).child("Friends")
        selfFriendRef.removeValue()
    }
    
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
    

    //Download the data from Firebase:
    static func checkData(completed: @escaping ()-> ()) {
        
        let databaseRef = Database.database().reference()
        if let user = Auth.auth().currentUser {
            
            DataHandler.user = Auth.auth().currentUser
            DataHandler.uid = Auth.auth().currentUser?.uid
            
            databaseRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshotValue = snapshot.value as? NSDictionary
                
                //Checks to see whether or not the user has completed setup1 and entered their name.
                let name = snapshotValue?["Name"] as? String ?? ""
                if name == "" {
                    self.nameExists = false
                    print("Check Data: Name doesn't exist")
                }else{
                    self.nameExists = true
                    self.name = name
                    print("Check Data: Name exists - \(self.name)")
                }
                
                //Checks to see whether or not the user has completed setup2 and selected a picture.
                if snapshot.hasChild("Profile Picture"){
                    self.picExists = true
                    self.picURL = (snapshotValue!["Profile Picture"] as? String)!
                    print("Check Data: Picture exists - \(self.picURL)")
                }else{
                    print("Check Data: Picture doesn't exist")
                    self.picExists = false
                }
                
                //Checks to see whether or not the user has completed setup2 and selected a grade.
                if snapshot.hasChild("Grade"){
                    self.gradeExists = true
                    self.grade = (snapshotValue?["Grade"] as? String)!
                    print("Check Data: Grade exists - \(self.grade)")
                }else{
                    self.gradeExists = false
                    print("Check Data: Grade doesn't exist")
                }
                
                //Makes sure the mac status is correct.
                if snapshot.hasChild("Mac Status"){
                    self.macStatus = (snapshotValue?["Mac Status"] as? String)!
                    print("Check Data: Status exists - \(self.macStatus)")
                }else{
                    self.macStatus = ""
                    print("Check Data: Status doesn't exist")
                }
                
                //Download friends.
                if snapshot.hasChild("Friends"){
                    self.friends = (snapshotValue?["Friends"] as? NSDictionary)!
                    self.friendList = self.friendDictionaryToList(friends: self.friends as! [String : [String : String]])
                    print("Check Data: Friends exist")
                    print(self.friends)
                    print("Check Data: Friend check complete")
                }else{
                    self.friends = NSDictionary()
                    print("Check Data: Friends don't exist")
                }
                
                //Download interests.
                if snapshot.hasChild("Interests"){
                    self.interests = (snapshotValue?["Interests"] as? NSDictionary)!
                    print("Check Data: Interests exist - \(self.interests)")
                }else{
                    self.interests = NSDictionary()
                    print("Check Data: Interests don't exist")
                }
                
                //Download current match's conversation ID:
                if snapshot.hasChild("Current Match ID"){
                    let snapshotValue = snapshot.value as? NSDictionary
                    self.currentMatchID = (snapshotValue?["Current Match ID"] as? String)!
                    print("Check Data: Current match exists - \(self.currentMatchID)")
                    completed()
                }else{
                    self.currentMatchID = ""
                    print("Check Data: Current match doesn't exist")
                    completed()
                }
                
                
            }) //End of Firebase snapshot
        }//End of if let user condition

    }//End of checkData.

    
    //Included in checkData, but separated here just for friends.
    static func downloadFriends(completed: @escaping ()-> ()) {
        let databaseRef = Database.database().reference()
        if let user = Auth.auth().currentUser {
            databaseRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshotValue = snapshot.value as? NSDictionary
                
                //Download friends.
                if snapshot.hasChild("Friends"){
                    
                    //Save as both dictionary and list.
                    self.friends = (snapshotValue?["Friends"] as? NSDictionary)!
                    //self.friendList = self.friendDictionaryToList(friends: self.friends as! [String : [String : String]])
                    //Here's the problem - this part must execute INSIDE the closure.
                    
                    print("Download Friends: Friends exist")
                    print(self.friends)
                    print("Download Friends: Friend check complete")
                    completed()
                }else{
                    self.friends = NSDictionary()
                    print("Download Friends: Friends don't exist")
                    completed()
                }
                
            }) //End of Firebase snapshot
        }//End of if let user condition
        
    }//End of downloadFriends.
    
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
    
    
    
    
}//End of DataHandler
