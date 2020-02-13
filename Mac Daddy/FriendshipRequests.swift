//
//  FriendshipRequests.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/8/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import Firebase

class FriendshipRequests: NSObject {
    
    //MARK: Upgrade to FriendshipObject
    
    func upgradeFriendToFriendshipObject(friend: Friend) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        let ref = NetworkConstants().friendshipObjectsPath().document(friend.convoID)

        ref.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    print("👍🏼 FriendshipObject exists already.")
//                    print("FriendshipObject exists already. \(String(describing: document.data()))")
                } else {
                    print("🤦🏻‍♀️ FriendshipObject does not exist. Upgrading now...")
                    
                    let upgradedObject = FriendshipObject()
                    upgradedObject.convoId = friend.convoID
                    
                    
                    //MARK: Initiator and Reciever

                    //You started the match.
                    if DataHandler.currentMatchID == friend.uid {
                        upgradedObject.initiatorId = Auth.auth().currentUser?.uid
                        upgradedObject.recieverId = friend.uid
                        
                    } else {
                    //They started the match.
                        upgradedObject.recieverId = Auth.auth().currentUser?.uid
                        upgradedObject.initiatorId = friend.uid
                    }
                    
                    //MARK: Members

                    var members = [String]()
                    members.append(upgradedObject.initiatorId!)
                    members.append(upgradedObject.recieverId!)
                    upgradedObject.members = members
                    
                    //MARK: Anonymity

                    if friend.anon == "1" {
                        upgradedObject.anon = true
                    } else {
                        upgradedObject.anon = false
                    }
                    
                    //MARK: Insert
                    print("Friendship object: \(upgradedObject)")
                    self.insertNewFriendshipObjectInFirestore(friendship: upgradedObject)
                    
                } //End of if document.exists condition
            }//End of if let document condition
        }//End of get document call
    }//End of function
    
    
     //MARK: Insert & Update FriendshipObjects
    
    func updateFriendshipObjectInFirestore(friendship: FriendshipObject) {
        if friendship.convoId != nil {
            let ref = NetworkConstants().friendshipObjectPath(convoId: friendship.convoId!)
            guard let friendshipData = friendship.encodeModelObject() else {
                print ("Error encoding FriendshipObject")
                return
            }
            UserRequests().updateFirestoreData(ref: ref, values: friendshipData)
        } else {
            print("Friendship convo id is nil. This should not be happening.")
        }
    }
    
    func insertNewFriendshipObjectInFirestore(friendship: FriendshipObject) {
        if friendship.convoId != nil {
            let ref = NetworkConstants().friendshipObjectPath(convoId: friendship.convoId!)
            guard let friendshipData = friendship.encodeModelObject() else {
                print ("Error encoding FriendshipObject")
                return
            }
            UserRequests().setFirestoreData(ref: ref, values: friendshipData)
        } else {
            print("Friendship convo id is nil. This should not be happening.")
        }
    }
    
    //MARK: Download relevant FriendshipObjects
    
    func getMyFriendships()  {
        downloadMyFriendshipObjects {
            friendships in
            UserManager.shared.friendships = friendships
        }
    }
    
    func downloadMyFriendshipObjects(completion: @escaping (_ friendships: [FriendshipObject])-> ()) {
        
        guard let myUid = Auth.auth().currentUser?.uid else {
            print("User not signed in. Returning empty FriendshipObjects.")
            let emptyFriendships = [FriendshipObject]()
            completion(emptyFriendships)
            return
        }
        
        let ref = NetworkConstants().friendshipObjectsPath()
        let myFriendshipsRef = ref.whereField("members", arrayContains: myUid)
        
        var friendships = [FriendshipObject]()
        
        myFriendshipsRef.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching my friendships: \(error!)")
                return
            }
            for document in documents {
                
                let data = document.data() as NSDictionary
                if (!JSONSerialization.isValidJSONObject(data)) {
                    print("Data is not a valid json object")
                    return
                }
                if let friendship = decode(json: data, obj: FriendshipObject.self) {
                    friendships.append(friendship)
                } else {
                    print("Error decoding friendship JSON")
                }
            }
            
            //Sort friendships by time
            friendships = friendships.sorted(by: {
                $0.lastActive?.compare($1.lastActive ?? Date()) == .orderedDescending
            })
            
            NotificationCenter.default.post(name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
            print("Successfully downloaded FriendshipsObjects")
            completion(friendships)
        }
    }
    
    
    
    func observeMyFriendshipObjects(completion: @escaping (_ friendships: [FriendshipObject])-> ()) {
        print("👀 - observeMyFriendshipObjects function triggered")
        let ref = NetworkConstants().friendshipObjectsPath()
        let myUid = Auth.auth().currentUser?.uid ?? ""
        let query = ref.whereField("members", arrayContains: myUid)
        
        var friendships = [FriendshipObject]()
        
        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching my friendships: \(error!)")
                return
            }
            for document in documents {
                
                let data = document.data() as NSDictionary
                if (!JSONSerialization.isValidJSONObject(data)) {
                    print("Data is not a valid json object")
                    return
                }
                if let friendship = decode(json: data, obj: FriendshipObject.self) {
                    if self.friendshipExistsInFriendsList(friendship: friendship) {
                        friendships.append(friendship)
                    } else {
                        print("Skipping old friendship")
                    }
                } else {
                    print("Error decoding friendship JSON")
                }
            }
            
            //Sort friendships by time
            friendships = friendships.sorted(by: {
                $0.lastActive?.compare($1.lastActive ?? Date()) == .orderedDescending
            })
            
            NotificationCenter.default.post(name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
            
            completion(friendships)
        }
    }
    
    
    func friendshipExistsInFriendsList(friendship: FriendshipObject) -> Bool {
        var found = false
        if DataHandler.friendList.isEmpty {return false}
        if friendship.members == nil {return false}
        for friend in DataHandler.friendList {
            if (friendship.members?.contains(friend.uid))! {found = true}
        }
        return found
    }
    
    
    //MARK: Fetch cached friends both ways
    
    func fetchCachedFriendship(uid: String) -> FriendshipObject? {
        if UserManager.shared.friendships == nil {
            print ("Cached friendship could not be found")
            return nil
        } else {
            guard let friendships = UserManager.shared.friendships else {
                return nil
            }
            for friendship in friendships {
                if friendship.members == nil {
                    print("members are nil")
                } else if friendship.members!.contains(uid) {
                    return friendship
                }
            }
        }
        return nil
    }
    
    func fetchCachedFriendStruct(uid: String) -> Friend? {
        if DataHandler.friendList.isEmpty {
            print ("Cached friendship could not be found")
            return nil
        } else {
            for friend in DataHandler.friendList {
                if friend.uid == uid {
                    return friend
                }
            }
        }
        return nil
    }
    
    //MARK: Get the other person's id out
    func getFriendsUid(friendship: FriendshipObject?) -> String {
        if friendship == nil {
            print("Tried to get friends id from empty friendship object")
            return ""
        }
        if let myUid = UserManager.shared.currentUser?.uid {
            if friendship?.initiatorId == myUid {
                return friendship?.recieverId ?? ""
            } else {
                return friendship?.initiatorId ?? ""
            }
        }
        print("Error getting friend uid. My uid doesn't exist.")
        return ""
    }
    
    //MARK: Archive friendship
    
    
    func archiveFriendshipObject(friendship: FriendshipObject, completion: @escaping (_ success: Bool)-> ()) {
        self.insertFriendshipObjectInArchives(friendship: friendship, completion: { (success) in
            if success {
                self.deleteFriendship(friendship: friendship, completion: { (success) in
                    if success {
                        completion(true)
                    } else {
                        print("Error removing friendship object.")
                        completion(false)
                    }
                })
            } else {
                print("Error inserting into archives. Unable to delete friendship.")
                completion(false)
            }
        })
        
    
    }
    
    func insertFriendshipObjectInArchives(friendship: FriendshipObject, completion: @escaping (_ success: Bool)-> ()) {
        if friendship.convoId != nil {
            let ref = NetworkConstants().archivedFriendshipPath(convoId: friendship.convoId!)
            guard let friendshipData = friendship.encodeModelObject() else {
                print ("Error encoding FriendshipObject")
                completion(false)
                return
            }
            UserRequests().setFirestoreData(ref: ref, values: friendshipData)
            completion(true)
        } else {
            print("Friendship convo id is nil. This should not be happening.")
            completion(false)
        }
    }
    
    
    //MARK: Delete friendship
    func deleteFriendship(friendship: FriendshipObject, completion: @escaping (_ success: Bool)->()){
        if friendship.convoId == nil {
            print("Cannot delete friendship with empty convoId")
            completion(false)
        }
        NetworkConstants().friendshipObjectPath(convoId: friendship.convoId!).delete() { err in
            if let err = err {
                print("Error removing friendship: \(err)")
                completion(false)
            } else {
                print("Document successfully removed!")
                completion(true)
            }
        }
    }
    
    //MARK: Update your lastActive status
    func updateMyLastActiveStatusInAllFriendships(becomingActive: Bool) {
        print("Updating my last active status in all friendships")
        if let friendships = UserManager.shared.friendships {
            for friendship in friendships {
                       //If I'm the initiator
                       if friendship.initiatorId == UserManager.shared.currentUser?.uid {
                           friendship.initiatorLastActive = Date()
                           friendship.initiatorActive = becomingActive
                       } else if friendship.recieverId == UserManager.shared.currentUser?.uid{
                           friendship.recieverLastActive = Date()
                           friendship.recieverActive = becomingActive
                       }

                       FriendshipRequests().updateFriendshipObjectInFirestore(friendship: friendship)
                   }
        } else {
            print("No friendships to update.")
            return
        }
       
    }
    
}
