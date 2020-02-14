//
//  Matching.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/28/17.
//  Copyright © 2017 Synestha. All rights reserved.
//


//MARK: Deprecated

import Foundation
import Firebase

class Matching {
    
    static var candidates = [Friend]()
    static var chosenCandidate = Friend()
    
    //Matching algorithm goes here:
    static func filterCandidates(finished: @escaping ()-> ()){
        //Takes all eligible users from UserData.
        
        UserData.downloadAllUsers {
            //Clear out local array before you begin.
            candidates = [Friend]()
            
            var filteredCandidates = [Friend]()
            
            
            ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
            for user in UserData.allUsers {
                //Download all availible users and convert them to Friends in candidates.
                var newFriend = Friend()
                    
                newFriend.anon = user.anon
                newFriend.convoID = user.convoID
                newFriend.grade = user.grade
                newFriend.macStatus = user.macStatus
                newFriend.name = user.name
                newFriend.uid = user.uid
                newFriend.weight = user.weight
                newFriend.active = user.active
                newFriend.secondaryA = user.secondaryA
                
                candidates.append(newFriend)
            }//All users have been filtered and converted to candidates.
            
            //Important initial steps:
            //1. Take yourself, out of the list with some JAVA LOOKING LOOPS
            var i = 0
            while (i < candidates.count) {
                if candidates[i].uid == DataHandler.uid! {
                    print("Removing self: \(candidates[i])")
                    candidates.remove(at: i)
                    i = i - 1
                }
                i = i + 1
            }
            
            //2. Take out your current friends.
            i = 0
            while (i < candidates.count) {
                //Leave it to me to write trash n squared code...
                var j = 0
                var remove = false
                while ( j < DataHandler.friendList.count
                    && DataHandler.friendList.count != 0
                    && candidates.count != 0
                    && remove == false) {
                        
                        print("Checking Candidate i = \(i)")
                        if candidates[i].uid == DataHandler.friendList[j].uid {
                            remove = true
                        } //End of checking against friend at j
                        j = j + 1
                } // End of checking candidate at i
                if remove {
                    print("❄️ Removing current friend: \(candidates[i])")
                    candidates.remove(at: i)
                    i = i - 1
                }
                i = i + 1
            }//End of checking all candidates
            
            
            //Refine weights based on criteria.
            //Status is most important, then availibility, then everything else is extra.
            for candidate in candidates {
                var updatedCandidate = candidate
                if DataHandler.macStatus != candidate.macStatus {
                    updatedCandidate.weight = candidate.weight + 100
                }
                
//                if candidate.secondaryA == "1" {
//                    updatedCandidate.weight += 50
//                }
                
                filteredCandidates.append(updatedCandidate)
            }
            
            candidates = filteredCandidates
            print("Here are the candidates: \(candidates)")

            
            //NOW only keep the candidates of max weight.
            //Add some noise into this function for randomness?
            
            //First find what the max weight is:
            var maxWeight = 0
            for candidate in candidates {
                if candidate.weight > maxWeight {
                    maxWeight = candidate.weight
                }
            }
             print("❄️ Max weight = \(maxWeight)")
            
            //Clear out the filtered candidates:
            filteredCandidates = [Friend]()
            
            //Add the highest weighted candidates to filteredCandidates:
            for candidate in candidates {
                if candidate.weight == maxWeight {
                    filteredCandidates.append(candidate)
                }
            }
            
            candidates = filteredCandidates
            finished()
            
            
        }//End of downloadAllUsers closure
    }//End of filterCandidates method.
    
    static func findMatch(completed: @escaping ()-> ()) {
        //let friends = DataHandler.friendDictionaryToList(friends: DataHandler.friends as! [String : [String : String]])
        
        //All sorting can only take place after the candidates have been downloaded.
        filterCandidates {
            print("We have \(candidates.count) eligible candidates.")
            
            
            if candidates.count > 0 {
                //Now pick a random candidate! (Don't actually pick random until you're down to a small pool)
                let randomIndex = Int(arc4random_uniform(UInt32(candidates.count)))
                print("Random index is \(randomIndex)")
                self.chosenCandidate = candidates[randomIndex]
                
                //Assign a random name!
                let anonName = "Anonymous " + Constants.fakeNames[Int(arc4random_uniform(UInt32(Constants.fakeNames.count)))]
                self.chosenCandidate.name = anonName
                self.chosenCandidate.convoID = createConvoID()
                
                //Push data to initialize the conversation:
                let ref = Constants.refs.databaseConversations.child(chosenCandidate.convoID).child("status")
                let myUID = DataHandler.uid!
                let friendUID = chosenCandidate.uid
                let status = [myUID: ["saved": "0"], friendUID: ["saved": "0"]]
                ref.setValue(status)
                
                //Update availibility locally and in Firebase.
                
                DataHandler.updatePrimaryA(primaryA: "1")
                DataHandler.updateFriendData(friend: chosenCandidate, newMatch: true)
                //Update your own current match:
                DataHandler.updateCurrentMatchID(currentMatchID: chosenCandidate.uid)
                
                completed()
                
            } else {
                //If there are no candidates
                self.chosenCandidate = Friend()
                print("Match could not be found")
                
                completed()
            }
            
            //Clear out local array when you're done.
            candidates = [Friend]()
        }
    }//End of findMatch method
    
    static func createConvoID() -> String {
        let newConvoID = Constants.refs.databaseConversations.childByAutoId()
        return newConvoID.key!
    }
    
    
    //Friending functions
    static func saveCurrentMatch(friend:Friend) {
        let ref = Constants.refs.databaseConversations.child(friend.convoID).child("status")
        let myUID = DataHandler.uid!
        let status = [myUID: ["saved": "1"]]
        ref.updateChildValues(status)
    }
    
//    static func downloadSelectUsers(myEmail : String){
//
//        let users = [DownloadedUser]()
//        //need to add email field to db
//        let userRef = DataHandler.db.collection("users").whereField("Email", isGreaterThan: myEmail).whereField("Email", isLessThan: myEmail)
//
//        DataHandler.db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("friends").getDocuments(){ (qs, err) in
//            for doc in qs?.documents{
//                userRef.whereField("Email", isGreaterThan: doc.data()[/*need email*/]).whereField("Email", isLessThan: doc.data()[/*need email*/])
//            }
//            userRef.getDocuments(){ (qs, err) in
//                if let err = err {
//                    print("💥 Error getting users: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//
//                        let userObject = userDictionaryToList(uid: document.documentID, data: document.data() as! [String : String])
//                        users.append(userObject)
//                    }
//                    print("🦋 Downloaded all users: \(users)")
//                    completed()
//                }
//            }
//        }
//    }

}
