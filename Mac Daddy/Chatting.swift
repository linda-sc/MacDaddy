//
//  Chatting.swift
//  Mac Daddy
//
//  Created by Linda Chen on 3/19/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation
import Firebase

////////////////////////////////////////////
/////////  UPDATE FOR FIRESTORE  ///////////
////////////////////////////////////////////

//All the Firebase stuff:
extension ChatInterfaceVC {
    
    //Remove the in-chat observers when the view is gone.
    override func viewWillDisappear(_ animated: Bool) {
        let convoRef = Database.database().reference().child("conversations").child(friend.convoID).child("status")
        
        //Remove the observers, otherwise they'll keep firing even if the conversation is gone.
        //You might want to change this later, because you want to listen in for new messages...
        //Actually they should still disappear, and the observers should stick around in HomeVC.
        
        convoRef.removeAllObservers()
    }
    
    func addDeletionObserver() {
        let convoRef = Database.database().reference().child("conversations").child(friend.convoID)
        //Reference the current conversation
        
        convoRef.observe(.childRemoved, with: { snapshot in
            print("ChatInterfaceVC - addObserver: Listener fired")
            //Listener will always be firing to see if this particular convo has been deleted.
            
            self.convoStillExists {
                if self.convoExists == false {
                    self.showUnfriendAlert()
                }//Convo does exist
            }//End of closure
        }) //End of snapshot
    }
    
    
    func addSavedObserver() {
        
        let convoStatusRef = Database.database().reference().child("conversations").child(friend.convoID).child("status")
        
        convoStatusRef.observe(.value, with: { snapshot in
            print("ChatInterfaceVC - addObserver: Listener fired")
            //Listener will always be firing, but nothing will happen if the conversation has been deleted.
            
            self.convoStillExists {
                if self.convoExists {
                    
                    //Some messy casting to retrieve saved values:
                    let status = snapshot.value as! NSDictionary
                    
                    let myStatus = status[DataHandler.uid!] as! NSDictionary
                    let friendStatus = status[self.friend.uid]! as! NSDictionary
                    
                    let mySavedStatus = myStatus["saved"] as! String
                    let friendSavedStatus = friendStatus["saved"] as! String
                    
                    if (mySavedStatus == "1") {
                        print("I saved the chat, my firebase status is 1.")
                        self.heartButton.tintColor = UIColor(red: 0.99, green: 0.24, blue: 0.56, alpha: 1.00)
                        self.iSaved = true
                    } else {
                        self.heartButton.tintColor = UIColor.white
                    }
                    if (friendSavedStatus == "1") {
                        print("They saved the chat!")
                        self.theySaved = true
                    }
                    
                    //This only happens once, when you check and see that both chats are saved:
                    //Might not work, depends on how the code here executes.
                    if (self.iSaved && self.theySaved && self.anon) {
                        print("Both are saved")
                        //You're friends! Show an alert here.
                        self.anon = false
                        //Change your names in each other's friend lists and update the current friend's name.
                        self.getFriendsRealName {
                            self.showFriendAlert()
                        }
                    }
                }//Convo does exist
            }//End of closure
        }) //End of snapshot
    }
    
    
    //Shorter, faster function for just listening to typing:
    func addTypingObserver() {
        let friendTypingRef = Database.database().reference().child("conversations").child(friend.convoID).child("status").child(self.friend.uid).child("typing")
        friendTypingRef.observe(.value, with: { snapshot in
            print("ChatInterfaceVC - addTypingObserver: Listener fired")
            
            if let isTyping = snapshot.value as? String {
                //Now just listen for typing:
                if (isTyping == "1") {
                    self.friendTyping = true
                } else {
                    self.showTypingIndicator = false
                }
            }
        })
    }
    
    
    func updateTypingStatus() {
        
    }
    
    //Need escaping because for some reason the checking code doesn't execute in order.
    //This code works.
    //Let's change this so that it checks to see if the status exists.
    //If there's no status then it means the other user deleted the conversation.
    
    
    func convoStillExists(completed: @escaping ()-> ()) {
        if let _ = Auth.auth().currentUser {
            Constants.refs.databaseConversations.child(self.friend.convoID).observeSingleEvent(of: .value, with: { (snapshot) in
                //If the conversation exists then you're good to go.
                //If the snapshot is nil, that's fine, you just know it doesn't exist.
                if snapshot.hasChild("status"){
                    self.convoExists = true
                    completed()
                } else {
                    self.convoExists = false
                    completed()
                }
            }) //End of snapshot
        }//End of if let user condition
    }
    

    func getFriendsRealName(completed: @escaping ()-> ()) {
        
        DataHandler.db.collection("users").document(self.friend.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if let friendData = document.data() {
                    self.friendsRealName = friendData["5: Name"] as? String ?? ""
                }                
                let update = ["Name": self.friendsRealName, "Anon": "0"]
                let myFriendsRef = DataHandler.db.collection("users").document(DataHandler.uid!).collection("friends").document(self.friend.uid)
                DataHandler.updateFirestoreData(ref: myFriendsRef, values: update)
                DataHandler.freeUpAvailability(friend: self.friend)
                print("Name, anon, and availiability updated.")
                completed()
                
            } else {
                print("🍅 Cannot get user's real name")
            }
        }
    }

    
}
