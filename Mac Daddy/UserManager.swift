//
//  UserManager.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/9/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation

class UserManager: NSObject {
    
    //Create a shared instance of the UserManager object for all your files to reference.
    static let shared: UserManager = {
        let instance = UserManager()
        return instance
    }()

    var currentUser: UserObject?
    //let locationManager = CLLocationManager()
    
    //Register new user
    //Sign in user
    
    //////////////////////////////////////////////////
    // MARK: Converts email string into org tag
    //////////////////////////////////////////////////
    func organizationFromEmail(email: String) -> String {
        if email.hasSuffix("@bc.edu") {
            return ("BC")
        
        } else if email.hasSuffix("@bu.edu") {
            return ("BU")
            
        } else if email.hasSuffix("@harvard.edu") {
            return ("Harvard")
            
        } else if email.hasSuffix("@cornell.edu") {
            return ("Cornell")
            
        } else if email.hasSuffix("@brown.edu") {
            return ("Brown")
            
        } else if email.hasSuffix("@berkeley.edu") {
            return ("Berkeley")
            
        } else if email.hasSuffix("@ucla.edu") {
            return("UCLA")
        
        } else if email.hasSuffix("@uchicago.edu") {
            return("UChicago")
            
        } else if email.hasSuffix("@cooper.edu") {
            return("Cooper")
        
        } else {
            return ("None")
        }
    }
    
    
    //////////////////////////////////////////////////
    // MARK: Update current location
    //////////////////////////////////////////////////
    func updateCurrentLocation(){
        UserManager.shared.currentUser!.latitude = CLLocationCoordinate2D().latitude
        UserManager.shared.currentUser!.latitude = CLLocationCoordinate2D().longitude
    }
    
    
}


//////////////////////////////////////////////////
//////////////////////////////////////////////////
// MARK: This extension contains functions to
// convert from DataHandler
//////////////////////////////////////////////////
//////////////////////////////////////////////////
extension UserManager {
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: 1. Function that creates a currentUser
    // object from the DataHandler variables.
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    func importCurrentUserFromDataHandler(){
        //Note: even though we are updating the data of userCopy, the reference never changes.
        // That's why it should be a let constant instead of a var variable.
        let userCopy = UserObject()
        
        //1. Basic Information
        userCopy.uid = Auth.auth().currentUser?.uid
        userCopy.email = Auth.auth().currentUser?.email
        userCopy.organization = organizationFromEmail(email: userCopy.email ?? "")
        userCopy.credentialsProvider = Auth.auth().currentUser?.providerID
        userCopy.userPlatform = "iOS"
        
        //2. Onboarding variables
        userCopy.setup1Complete = DataHandler.nameExists
        userCopy.setup2Complete = DataHandler.picExists
        userCopy.setup3Complete = DataHandler.gradeExists
        
        //3. Custom Information
        userCopy.firstName = DataHandler.name
        userCopy.profilePicUrl = DataHandler.picURL
        userCopy.grade = DataHandler.grade
        userCopy.status = DataHandler.macStatus
        
        //4. Realtime Information
        userCopy.currentMatchID = DataHandler.currentMatchID
        userCopy.lastActive = Date()
        
        UserManager.shared.currentUser = userCopy
    }
    
    
}
