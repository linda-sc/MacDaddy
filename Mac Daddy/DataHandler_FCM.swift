//
//  DataHandler_FCM.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/21/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation
import Firebase

extension DataHandler {
    
    static func sendRegistrationToServer(token: String) {
        if let uid = Auth.auth().currentUser?.uid {
            DataHandler.updateUserData(uid: uid, values: ["FCMToken" : token])
        }
    }
    
}
