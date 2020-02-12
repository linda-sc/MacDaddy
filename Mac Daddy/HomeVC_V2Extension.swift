//
//  HomeVC_V2Extension.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/10/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import Firebase

extension HomeVC {
    
    //MARK: Called in ViewDidLoad
    
    func viewDidLoadExtension() {

        UserManager.shared.getLocation()
        UserRequests().checkupUpdates()
        self.refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRecieveUpdatedFriendshipObjects(_:)), name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
    }
    
    //MARK: Function called when logo tapped
    func refresh() {
        if let myFriendships = UserManager.shared.friendships {
            updateMyLastActiveStatus(friendships: myFriendships)
            self.updatedActiveStatusOnce = true
        }
    }

    //MARK: Stuff to do when objects update

    @objc func onDidRecieveUpdatedFriendshipObjects(_ notification:Notification) {
        print("FriendshipObjects updated")
        self.tableView.reloadData()
    }
    
    //MARK: Update your lastActive status
    func updateMyLastActiveStatus(friendships: [FriendshipObject]) {
        print("Updating my last active status in all friendships")
        for friendship in friendships {
            //If I'm the initiator
            if friendship.initiatorId == UserManager.shared.currentUser?.uid {
                friendship.initiatorLastActive = Date()
            } else {
                friendship.recieverLastActive = Date()
            }
            
            FriendshipRequests().updateFriendshipObjectInFirestore(friendship: friendship)
        }
    }
    
}
