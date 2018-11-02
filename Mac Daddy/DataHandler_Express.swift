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
    
    ///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜
    
    //Update the user's availibility as an initiator in Firebase.
    static func updatePrimaryA(primaryA:String) {
        updateUserData(uid: uid!, values: ["1: PrimaryA": primaryA])
    }
    
    //Update the user's availibility as a reciever in Firebase.
    static func updateSecondaryA(secondaryA:String) {
        updateUserData(uid: uid!, values: ["2: SecondaryA": secondaryA])
    }
    
    //Update the user's organzation in Firebase.
    static func updateOrganization(organization:String) {
        updateUserData(uid: uid!, values: ["3: Organization": organization])
    }
    
    //Update the user's email in Firebase.
    static func updateEmail(email:String) {
        updateUserData(uid: uid!, values: ["4: Email": email])
    }
    
    //Update the user's name in Firebase.
    static func updateName(name:String) {
        updateUserData(uid: uid!, values: ["5: Name": name])
    }
    
    //Update the user's Mac Status in Firebase.
    static func updateMacStatus(status:String) {
        updateUserData(uid: uid!, values: ["6: MacStatus": status])
    }
    
    //Update the user's current match in Firebase and in DataHandler.
    static func updateCurrentMatchID(currentMatchID:String) {
        updateUserData(uid: uid!, values: ["7: MatchID": currentMatchID])
        self.currentMatchID = currentMatchID
    }
    
    //Update the user's status variables.
    static func updateActive(active: String) {
        //let currentDateTime = Date().timeIntervalSinceReferenceDate
        
        if let uid = uid {
            updateUserData(uid: uid, values: ["8: Active": active])
            updateActivityinFriendsLists(active: active)
        }
    }
    
    //Update the user's current match in Firebase and in DataHandler.
    static func updateGrade(grade:String) {
        updateUserData(uid: uid!, values: ["9: Grade": grade])
    }
    
}

