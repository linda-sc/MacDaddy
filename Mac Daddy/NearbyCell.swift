//
//  NearbyCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/16/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var userObject = UserObject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadCell(for user: UserObject) {
        avatarView.displayAvatar(avatar: user.avatar)
        if user.currentLocation != nil {
            displayDistanceInMiles(friendLocation: user.currentLocation!)
        } else {
            self.distanceLabel.text = "???"
        }
    }
    

    func displayDistanceInMiles(friendLocation: CLLocation) {
        if let myLocation = UserManager.shared.currentLocation {
            let distanceInMeters = friendLocation.distance(from: myLocation)
            if(distanceInMeters <= 1609) {
               let distanceInFeet = distanceInMeters * 3.281
               let s = String(format: "%.1f", distanceInFeet)
               self.distanceLabel.text = s + " ft"
            } else {
               let distanceInMiles = distanceInMeters * 0.000621371
               let s = String(format: "%.0f", distanceInMiles)
               self.distanceLabel.text = s + " mi"
            }
        }
    }
    

}
