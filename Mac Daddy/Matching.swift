//
//  Matching.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/28/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase

class Matching {
    
    static var candidates = [Friend]()
    static var chosenCandidate = Friend()
    
    static let fakeNames = ["Chicken Tender", "Cheeseburger", "Pizza", "Chicken Salad Wrap", "Mozzarella Stick", "Omelette", "Bagel", "Bacon", "Sausage", "Meatball", "Mashed Potato", "French Fry", "String Bean", "Panini", "Potato Chip", "Pineapple", "Quinoa Bowl", "Kale Bowl", "Clam Chowder", "Piece of Steak", "Broccoli", "Blueberry Muffin", "Chocolate Cake", "Noodle Bowl", "Spaghetti", "Steak and Cheese", "Sticky Rice", "Pancake", "Waffle", "Tortilla" , "Tortellini" , "Acai Bowl" , "Salmon" , "Cod", "French Toast", "Bread", "Zucchini", "Eggplant", "Banana", "Brownie", "Coconut Water", "Iced Chai Latte", "Chicken Pesto" , "Chicken Wing", "Pork Belly", "Mac and Cheese", "Powerade", "Spinach", "Ice Cream", "Baguette", "Donut", "Corn Dog", "Hot Dog", "Corn", "Beans", "Chicken Parm"]
    
    
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
                if user.secondaryA == "1" {
                //if true {
                    var newFriend = Friend()
                    
                    newFriend.anon = user.friendInfo.anon
                    newFriend.convoID = user.friendInfo.convoID
                    newFriend.grade = user.friendInfo.grade
                    newFriend.macStatus = user.friendInfo.macStatus
                    newFriend.name = user.friendInfo.name
                    newFriend.uid = user.friendInfo.uid
                    newFriend.weight = user.friendInfo.weight
                    newFriend.active = user.friendInfo.active
                    
                    candidates.append(newFriend)
                }
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
            
            
            //Next:
            //Refine weights based on criteria
            if DataHandler.macStatus == "Daddy" {
                for candidate in candidates {
                    if candidate.macStatus == "Baby" {
                        var updatedCandidate = candidate
                        updatedCandidate.weight = candidate.weight + 100
                        filteredCandidates.append(updatedCandidate)
                    }
                }
                candidates = filteredCandidates
                print("Here are the candidates: \(candidates)")
                
            } else {
                for candidate in candidates {
                    if candidate.macStatus == "Daddy" {
                        var updatedCandidate = candidate
                        updatedCandidate.weight = candidate.weight + 100
                        filteredCandidates.append(updatedCandidate)
                    }
                }
                candidates = filteredCandidates
                print("Here are the candidates: \(candidates)")
            }
            
            //NOW only keep the candidates of max weight.
            //Status is most important, then availibility, then everything else is extra.
            
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
                let anonName = "Anonymous " + fakeNames[Int(arc4random_uniform(UInt32(fakeNames.count)))]
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
        return newConvoID.key
    }
    
    
    //Friending functions
    static func saveCurrentMatch(friend:Friend) {
        let ref = Constants.refs.databaseConversations.child(friend.convoID).child("status")
        let myUID = DataHandler.uid!
        let status = [myUID: ["saved": "1"]]
        ref.updateChildValues(status)
    }
}
