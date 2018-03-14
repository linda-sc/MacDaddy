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
            
            for user in UserData.allUsers {
                //Download all availible users and convert them to Friends in candidates.
                //if user.secondaryA == "y" {
                if true {
                    var newFriend = Friend()
                    
                    newFriend.anon = user.anon
                    newFriend.convoID = user.convoID
                    newFriend.grade = user.grade
                    newFriend.macStatus = user.macStatus
                    newFriend.name = user.name
                    newFriend.uid = user.uid
                    newFriend.weight = user.weight
                    newFriend.active = user.active
                    
                    candidates.append(newFriend)
                }
            }//All users have been filtered and converted to candidates.
            
            //Important initial steps:
            //Take yourself out of the list with some JAVA LOOKING LOOPS
            var i = 0
            while (i < candidates.count) {
                if candidates[i].uid == DataHandler.uid! {
                    candidates.remove(at: i)
                    print("Removing self")
                    i = i - 1
                    
                    //Take out your current friends too.
                    //Remember to look at DataHandler!!
                    
                    //Leave it to me to write trash n squared code...
                    var j = 0
                    while (j < candidates.count
                            && j < DataHandler.friendList.count
                            && DataHandler.friendList.count != 0
                            && candidates.count != 0) {
                                
                        if candidates[i].uid == DataHandler.friendList[j].uid {
                            candidates.remove(at: i)
                            print("Removing current friends")
                            i = i - 1
                        }
                        j = j + 1
                    }
                }
                i = i + 1
            }
            
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
                let status = [myUID: ["saved": "n"], friendUID: ["saved": "n"]]
                ref.setValue(status)
                
                //Update availibility locally and in Firebase.
                DataHandler.updatePrimaryAvailibility(primaryAvailibility: "n")
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
        let status = [myUID: ["saved": "y"]]
        ref.updateChildValues(status)
    }
}
