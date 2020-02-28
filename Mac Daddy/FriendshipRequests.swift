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
    
    static var queryHandle: ListenerRegistration? = nil
    
    //MARK: Upgrade to FriendshipObject
    
    func upgradeFriendToFriendshipObject(friend: Friend) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        let ref = NetworkConstants().friendshipObjectsPath().document(friend.convoID)

        ref.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    print("👍🏼 FriendshipObject exists already.")
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
                    
                     //MARK: Other
                    upgradedObject.friendshipNickname = ""
                    
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
        print("💅🏻 - downloadMyFriendshipObjects function called")

        
        guard let myUid = Auth.auth().currentUser?.uid else {
            print("User not signed in. Returning empty FriendshipObjects.")
            let emptyFriendships = [FriendshipObject]()
            completion(emptyFriendships)
            return
        }
        
        let ref = NetworkConstants().friendshipObjectsPath()
        let myFriendshipsRef = ref.whereField("members", arrayContains: myUid)
        
        var tempFriendships = [FriendshipObject]()
        
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
                    if self.friendshipExistsInFriendsList(friendship: friendship) {
                        tempFriendships.append(friendship)
                    } else {
                        print("Skipping old friendship")
                    }
                } else {
                    print("Error decoding friendship JSON")
                }
            }
            
            //Sort friendships by time
            tempFriendships = tempFriendships.sorted(by: {
                $0.lastActive?.compare($1.lastActive ?? Date()) == .orderedDescending
            })
            
            print("UPDATED FRIENDSHIPS:")
            for friendship in tempFriendships {
                print(friendship.initiatorId)
                print(friendship.lastActive?.getElapsedInterval())
            }
            
            NotificationCenter.default.post(name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
            print("Successfully downloaded FriendshipsObjects")
            UserManager.shared.friendships = tempFriendships
            completion(tempFriendships)
        }
    }
    
    
    //MARK: Observe relevant FriendshipObjects
    
    func observeMyFriendshipObjects(completion: @escaping (_ friendships: [FriendshipObject])-> ()) {
        
        if FriendshipRequests.queryHandle != nil { return }
        
        print("👀🧜‍♀️ - observeMyFriendshipObjects function triggered")
        let ref = NetworkConstants().friendshipObjectsPath()
        let myUid = Auth.auth().currentUser?.uid ?? ""
        let query = ref.whereField("members", arrayContains: myUid)
        
        var friendships = [FriendshipObject]()
        
        FriendshipRequests.self.queryHandle = query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching my friendships: \(error!)")
                return
            }
            
            if let error = error {
                print("Error retreiving collection: \(error)")
                //Automatically detaches listener here.
            }
            
            for document in documents {
                
                let data = document.data() as NSDictionary
                if (!JSONSerialization.isValidJSONObject(data)) {
                    print("Data is not a valid json object")
                    return
                }
                if let friendship = decode(json: data, obj: FriendshipObject.self) {
                    //friendships.append(friendship)
                    
                    if self.friendshipExistsInFriendsList(friendship: friendship) {
                        friendships.append(friendship)
                    } else {
                        print("Skipping old friendship: \(friendship.members)")
                    }
                    
                } else {
                    print("Error decoding friendship JSON")
                }
            }
            
            //Sort friendships by time
            let oldDate = Date(timeIntervalSince1970: 0)
            friendships = friendships.sorted(by: {
                $0.lastActive?.compare($1.lastActive ?? oldDate) == .orderedDescending
            })
            
            print("Observed \(friendships.count) friendships")
            print("Posting Notification")
            //UserManager.shared.friendships = friendships
            NotificationCenter.default.post(name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
            
            completion(friendships)
        }
    }
    
    
    //MARK: Remove Observer
    func removeFriendshipObserver(){
        print("😴😴😴 - Removing observer")
        FriendshipRequests.queryHandle?.remove()
        FriendshipRequests.queryHandle = nil
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
    
      //MARK: Observe ALL FriendshipObjects
        
        func observeAllFriendshipObjects(completion: @escaping (_ friendships: [FriendshipObject])-> ()) {
            print("👀 - observeMyFriendshipObjects function triggered")
            let ref = NetworkConstants().friendshipObjectsPath()
            let myUid = Auth.auth().currentUser?.uid ?? ""
            
            var friendships = [FriendshipObject]()
            
            ref.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching my friendships: \(error!)")
                    return
                }
                
                if let error = error {
                    print("Error retreiving collection: \(error)")
                    //Automatically detaches listener here.
                }
                
                for document in documents {
                    
                    let data = document.data() as NSDictionary
                    if (!JSONSerialization.isValidJSONObject(data)) {
                        print("Data is not a valid json object")
                        return
                    }
                    if let friendship = decode(json: data, obj: FriendshipObject.self) {
                        
                        if friendship.members?.contains(myUid) ?? false {
                            friendships.append(friendship)
                        }
                        
    //                    if self.friendshipExistsInFriendsList(friendship: friendship) {
    //                        friendships.append(friendship)
    //                    } else {
    //                        print("Skipping old friendship: \(friendship.members)")
    //                    }
                    } else {
                        print("Error decoding friendship JSON")
                    }
                }
                
                //Sort friendships by time
                let oldDate = Date(timeIntervalSince1970: 0)
                friendships = friendships.sorted(by: {
                    $0.lastActive?.compare($1.lastActive ?? oldDate) == .orderedDescending
                })
                
                print("Observed \(friendships.count) friendships")
                
                //UserManager.shared.friendships = friendships
                NotificationCenter.default.post(name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
                
                completion(friendships)
            }
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
                //Second order of business: Delete once you're done archiving
                if friendship.convoId == nil {
                    completion(false)
                }
                self.deleteFriendship(friendship: friendship, convoId: friendship.convoId!, completion: { (success) in
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
    
    //FIrst order of business: archiving
    private func insertFriendshipObjectInArchives(friendship: FriendshipObject, completion: @escaping (_ success: Bool)-> ()) {
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
    //Third order of business - mechanic for actually deleting friendship
    private func deleteFriendship(friendship: FriendshipObject?, convoId: String, completion: @escaping (_ success: Bool)->()){
//        if friendship?.convoId == nil {
//            print("Cannot delete friendship with empty convoId")
//            completion(false)
//        }
        let id = friendship?.convoId ?? convoId
        NetworkConstants().friendshipObjectPath(convoId: id).delete() { err in
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
                if friendship.iAmInitiator() {
                    friendship.initiatorLastActive = Date()
                    friendship.initiatorActive = becomingActive
                } else if friendship.iAmReceiver() {
                    friendship.recieverLastActive = Date()
                    friendship.recieverActive = becomingActive
                }
                
                //Random other stuff to update:
                if friendship.friendshipNickname == nil {
                    friendship.friendshipNickname = ""
                }
                
                FriendshipRequests().updateFriendshipObjectInFirestore(friendship: friendship)
           }
        } else {
            print("No friendships to update.")
            return
        }
    }
    
    func updateMyAvatarInAllFriendships() {
        if let friendships = UserManager.shared.friendships {
            for friendship in friendships {
                if friendship.iAmInitiator() {
                    friendship.initiatorAvatar = UserManager.shared.currentUser?.avatar
                } else if friendship.iAmReceiver() {
                    friendship.recieverAvatar = UserManager.shared.currentUser?.avatar
                }
                FriendshipRequests().updateFriendshipObjectInFirestore(friendship: friendship)
           }
        } else {
            print("No friendships to update.")
            return
        }
    }
    
    //MARK: Begin New Friendship

    func beginNewFriendship(userObject: UserObject, convoId: String, origin: String) -> FriendshipObject? {
        
        //First create the local object:
        let newFriendship = FriendshipObject()
        let me = UserManager.shared.currentUser
        
        newFriendship.lastActive = Date()
        newFriendship.convoId = convoId
        newFriendship.members = [String]()
        newFriendship.members?.append(me!.uid!)
        newFriendship.members?.append(userObject.uid!)
        
        newFriendship.initiatorId = Auth.auth().currentUser?.uid ?? me?.uid
        newFriendship.initiatorAvatar = me?.avatar
        newFriendship.initiatorLastActive = Date()
        
        
        newFriendship.recieverId = userObject.uid
        newFriendship.recieverAvatar = userObject.avatar
        newFriendship.recieverLastActive = userObject.lastActive
        
        newFriendship.anon = true
        newFriendship.archived = false
        newFriendship.origin = origin
        
        self.insertNewFriendshipObjectInFirestore(friendship: newFriendship)
        //DO NOT append to the local array, because the observer will take care of that for us.
        return newFriendship
    }
    
    //MARK: Recover Archived Friendships
    func recoverArchivedFriendships() {
        for friendship in UserManager.shared.friendships! {
            let livingRef = NetworkConstants().friendshipObjectsPath().document(friendship.convoId!)
            let archivesRef = NetworkConstants().archivedFriendshipsPath().document(friendship.convoId!)
            
            livingRef.getDocument { (document, error) in
                if let document = document {
                    if document.exists{
                        
                        self.updateFriendshipObjectInFirestore(friendship: friendship)
                        archivesRef.delete()
                    }
                }
            }
        }
    }
    
    func healAllCorruptedFriendshipObjects() {
        let ref = NetworkConstants().friendshipObjectsPath()
        ref.getDocuments { (querySnapshot, error) in
            
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
                
                    if friendship.members == nil {
                        var healedFriendship = friendship
                        let initiatorId = friendship.initiatorId ?? ""
                        let receiverId = friendship.recieverId ?? ""
                        let membersArray = [initiatorId, receiverId]
                        healedFriendship.members = membersArray
                        self.updateFriendshipObjectInFirestore(friendship: healedFriendship)
                        print("Added members array to broken friendship")
                    }
                    
                } else {
                    print("Error decoding friendship JSON")
                }
            }
        }
            
    }
    
    //MARK: Fetch friendship from convoId
    func fetchCachedFriendshipFromConvoId(id: String) -> FriendshipObject? {
        if UserManager.shared.friendships == nil {return nil}
        for friendship in UserManager.shared.friendships! {
            if friendship.convoId == id {
                return friendship
            }
        }
        return nil
    }
    
    // MARK: Fetch convoId from friendsList
    func fetchConvoIdFromFriendsList(friendUid: String) -> String? {
        for friend in DataHandler.friendList {
            if friend.uid == friendUid {
                return friend.convoID
            }
        }
        return nil
    }

    // MARK: Download any FSO from firestore.
       //////////////////////////////////////////////////
       //////////////////////////////////////////////////
       func downloadFriendshipDocument(convoId: String, success: @escaping successAny, failure: @escaping failureClosure) {
           if convoId != "" {
            let ref = NetworkConstants().friendshipObjectPath(convoId: convoId)
               ref.getDocument { (document, error) in
                   if let document = document, document.exists {
                       let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                       //print("Fetching user document data: \(dataDescription)")
                       if let friendshipData = document.data() {
                           success(friendshipData)
                           print("Successfully downloaded friendship document")
                       } else {
                           print("Friendship document data is nil")
                           failure(defaultError)
                       }
                   } else {
                       print("Friendship document does not exist")
                       failure(defaultError)
                   }
               }
           }
       }
       
       //Pairs with previous method
       func fetchFriendshipObject(convoId: String, success: successAny? = nil, failure: failureClosure? = nil) {
           self.downloadFriendshipDocument(convoId: convoId, success: { (friendshipData) in
               if let friendshipObject = decode(json: friendshipData, obj: FriendshipObject.self) {
                   success?(friendshipObject)
                   print("Successfully fetched friendship object")
               } else {
                   print("Friendship document data is corrupted")
                   failure?(defaultError)
               }
           }) { (error) in
               print("Friendship not found")
               failure?(error)
           }
       }
}
