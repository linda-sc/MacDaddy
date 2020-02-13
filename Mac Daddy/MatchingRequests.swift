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
    
    
    func selectMatch(completion: @escaping (_ match: UserObject)-> ()) {
        //Step 1:
        UserData.downloadAllUserObjects {
            //Step 2:
            var candidates = [WeightedCandidate]()
            let cleanedUsers = removeMeAndMyFriends(users: UserData.allUserObjects)
            
            for user in cleanedUsers {
                var candidate = WeightedCandidate()
                candidate.user = user
                candidate.weight = self.assignWeight(candidate: user)
                candidates.append(candidate)
            }
            
            let orderedCandidates = candidates.sorted(by: {$0.weight > $1.weight })
            if let chosenUser = orderedCandidates.first?.user {
                completion(chosenUser)
            } else {
                print("Error finding match")
                completion(UserObject())
            }
        }
    }
    
    func removeMeAndMyFriends(users: [UserObject]) -> [UserObject] {
        let cleanedList = [UserObject]()
        for user in users {
            if !user.isMyFriend() && !user.isMe() {
                cleanedList.append(user)
            }
        }
        return cleanedList
    }
    
    //MARK: Weighting function
    func assignWeight(candidate: UserObject) -> Int {
        
    }
    
    static func createConvoID() -> String {
        let newConvoID = Constants.refs.databaseConversations.childByAutoId()
        return newConvoID.key!
    }
       
    
    
}
