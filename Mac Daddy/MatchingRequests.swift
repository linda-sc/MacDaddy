//
//  MatchingRequests.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/13/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import Firebase

class MatchingRequests {
    
    struct WeightedCandidate {
        var user: UserObject = UserObject()
        var weight: Int = 1
    }
    
    //Tripartite structure to hold all three representations
    struct FriendUserAndFriendship {
        var friend = Friend()
        var user = UserObject()
        var friendship = FriendshipObject()
    }
    
    //MARK: Returns all three representations
    //MARK: Friend, UserObject, and FriendshipObject
    func initiateMatch(random: Bool, completion: @escaping (_ match: FriendUserAndFriendship?)-> ()) {
        //Step 1:
        UserData.downloadAllUserObjects {
            //Step 2:
            var candidates = [WeightedCandidate]()
            let cleanedUsers = self.removeMeAndMyFriends(users: UserData.allUserObjects)
            
            for user in cleanedUsers {
                var candidate = WeightedCandidate()
                candidate.user = user
                candidate.weight = self.assignWeight(candidate: user)
                candidates.append(candidate)
            }
            
            let orderedCandidates = candidates.sorted(by: {$0.weight > $1.weight })
            if let chosenUser = orderedCandidates.first?.user {
                self.createFriendStructAndConvoFromNewMatch(user: chosenUser, completed: {
                    friend in
                    
                    var hybridObject = FriendUserAndFriendship()
                    hybridObject.friend = friend
                    hybridObject.user = chosenUser
                    hybridObject.friendship = FriendshipRequests().beginNewFriendship(userObject: chosenUser, convoId: friend.convoID, origin: "random")!
                    
                    completion(hybridObject)
                })
            } else {
                print("Error finding match")
                completion(FriendUserAndFriendship())
            }
        }
    }
    
    
    func initiateMatchFromPost(uid: String, origin: String, completion: @escaping (_ match: FriendUserAndFriendship?)-> ()) {
        
        UserRequests().fetchUserObject(userID: uid, success: { (result) in
            if let userObject = result as? UserObject {
                
                if userObject.isMyFriend() {
                    print("You are already friends with \(userObject.firstName)")
                    return
                }
                
                 self.createFriendStructAndConvoFromNewMatch(user: userObject, completed: {
                     friend in
                     
                     var hybridObject = FriendUserAndFriendship()
                     hybridObject.friend = friend
                     hybridObject.user = userObject
                    hybridObject.friendship = FriendshipRequests().beginNewFriendship(userObject: userObject, convoId: friend.convoID, origin: origin)!
                     
                     completion(hybridObject)
                 })
            }
        }) { (error) in
            print("Couldn't get match.")
        }
    }
    
    func removeMeAndMyFriends(users: [UserObject]) -> [UserObject] {
        var cleanedList = [UserObject]()
        for user in users {
            if !user.isMyFriend() && !user.isMe() {
                cleanedList.append(user)
            }
        }
        return cleanedList
    }
    
    //MARK: Weighting function
    func assignWeight(candidate: UserObject) -> Int {
        let randInt = Int.random(in: 0 ... 100)
        return randInt
    }
    
    //MARK: Create convo ID
    
    func createConvoID() -> String {
        let newConvoID = Constants.refs.databaseConversations.childByAutoId()
        return newConvoID.key!
    }
    
    
    //MARK: Old stuff to preserve V1 architecture
    //MARK: Creates convo and also
    //MARK: returns Friend struct linked to it
    func createFriendStructAndConvoFromNewMatch(user: UserObject, completed: @escaping(_ friend: Friend )->()){
        var newFriend = Friend()
        let convoId = createConvoID()
        
        newFriend.anon = "1"
        newFriend.convoID = convoId
        newFriend.uid = user.uid ?? "Error"
        newFriend.grade = user.grade ?? "Freshman"
        newFriend.macStatus = user.status ?? "Baby"

        //Assign a random name!
        let anonName = "Anonymous " + Constants.fakeNames[Int(arc4random_uniform(UInt32(Constants.fakeNames.count)))]
        newFriend.name = anonName
        
        //Push data to initialize the conversation:
        let ref = Constants.refs.databaseConversations.child(newFriend.convoID).child("status")
        let myUID = DataHandler.uid!
        let friendUID = newFriend.uid
        let status = [myUID: ["saved": "0"], friendUID: ["saved": "0"]]
        ref.setValue(status)
        
        DataHandler.updatePrimaryA(primaryA: "1")
        DataHandler.updateFriendData(friend: newFriend, newMatch: true)
        DataHandler.updateCurrentMatchID(currentMatchID: newFriend.uid)
        
        completed(newFriend)
    }
       
    
    
}
