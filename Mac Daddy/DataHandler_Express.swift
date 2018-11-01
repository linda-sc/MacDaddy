//
//  DataHandler_Express.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/18/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation
import Firebase


extension DataHandler {
    
    //Update the user's email in Firebase.
    static func updateEmail(email:String) {
        updateUserData(uid: uid!, values: ["Email": email])
    }
    
    //Update the user's name in Firebase.
    static func updateName(name:String) {
        updateUserData(uid: uid!, values: ["Name": name])
    }
    
    //Update the user's Mac Status in Firebase.
    static func updateMacStatus(status:String) {
        updateUserData(uid: uid!, values: ["Mac Status": status])
    }
    
    //Update the user's availibility as an initiator in Firebase.
    static func updatePrimaryA(primaryA:String) {
        updateUserData(uid: uid!, values: ["PrimaryA": primaryA])
    }
    
    //Update the user's availibility as a reciever in Firebase.
    static func updateSecondaryA(secondaryA:String) {
        updateUserData(uid: uid!, values: ["SecondaryA": secondaryA])
    }
    
    //Update the user's current match in Firebase and in DataHandler.
    static func updateCurrentMatchID(currentMatchID:String) {
        updateUserData(uid: uid!, values: ["Current Match ID": currentMatchID])
        self.currentMatchID = currentMatchID
    }
    
    //Update the user's status variables.
    static func updateStatusVariables(active: String) {
        //let currentDateTime = Date().timeIntervalSinceReferenceDate
        
        if let uid = uid {
            updateUserData(uid: uid, values: ["Active": active])
            updateActivityinFriendsLists(active: active)
        }
    }
    
}

