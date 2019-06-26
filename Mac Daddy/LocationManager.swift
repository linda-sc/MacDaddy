////
////  LocationManager.swift
////  Mac Daddy
////
////  Created by Linda Chen on 6/17/19.
////  Copyright © 2019 Synestha. All rights reserved.
////
//
//import Foundation
//
//class LocationManager: CLLocationManagerDelegate {
//
//    let locationManager = CLLocationManager()
//
//    func getLocation(){
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//    }
//
//    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.requestLocation()
//        case .denied:
//            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
//        case .restricted:
//            showAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app")
//        }
//    }
//
//    func showAlertToPrivacySettings(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
//            print("Something went wrong getting the UIApplicationOpenSettingsURLString")
//            return
//        }
//        let settingsActions = UIAlertAction(title: "Settings", style: .default) { value in
//            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(settingsActions)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        handleLocationAuthorizationStatus(status: status)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last
//        print("CURRENT LOCATION = \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
//        sortBasedOnSegmentPressed()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get user location.")
//    }
//}
