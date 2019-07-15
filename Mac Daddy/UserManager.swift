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
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    //Register new user
    //Sign in user
    
    //////////////////////////////////////////////////
    // MARK: Converts email string into org tag
    //////////////////////////////////////////////////
    func organizationFromEmail(email: String) -> String {
        if email.hasSuffix("@bc.edu") {
            return ("Boston College")
        
        } else if email.hasSuffix("@bu.edu") {
            return ("Boston University")
            
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
}


//////////////////////////////////////////////////
//////////////////////////////////////////////////
// MARK: This extension contains functions to
// convert from DataHandler
//////////////////////////////////////////////////
//////////////////////////////////////////////////
extension UserManager {
    
    //////////////////////////////////////////////////
    // MARK: 1. Function that creates a currentUser
    // object from the DataHandler variables.
    //////////////////////////////////////////////////
    func importCurrentUserFromDataHandler(){
        
        guard UserManager.shared.currentUser == nil else {
            print("UserObject already exists")
            return
        }
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


//////////////////////////////////////////////////
//////////////////////////////////////////////////
// MARK: UserManager also handles location
//////////////////////////////////////////////////
//////////////////////////////////////////////////
extension UserManager: CLLocationManagerDelegate {
    
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
        case .restricted:
            print("Location services denied.")
            //showAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            print("Something went wrong getting the UIApplicationOpenSettingsURLString")
            return
        }
        let settingsActions = UIAlertAction(title: "Settings", style: .default) { value in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsActions)
        alertController.addAction(cancelAction)
        //present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        UserManager.shared.currentUser?.latitude = currentLocation?.coordinate.latitude
        UserManager.shared.currentUser?.longitude = currentLocation?.coordinate.longitude
        UserManager.shared.currentUser?.currentLocation = locations.last
        
        print("CURRENT LOCATION = \(currentLocation?.coordinate.latitude) \(currentLocation?.coordinate.longitude)")
        
        UserRequests().insertUserInFirestore(userObject: UserManager.shared.currentUser!)
        //sortBasedOnSegmentPressed()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}
