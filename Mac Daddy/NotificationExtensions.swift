//
//  NotificationExtensions.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/10/20.
//  Copyright © 2020 Synestha. All rights reserved.
//


//https://learnappmaking.com/notification-center-how-to-swift/

import Foundation

extension Notification.Name {
    
    //MARK: Did download updated Friendships
    //Triggered by FriendshipRequests
    //Triggers HomeVC V2 Extension to reload table.
    static let onDidRecieveUpdatedFriendshipObjects = Notification.Name("onDidRecieveUpdatedFriendshipObjects")
}
