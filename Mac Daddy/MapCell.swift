//
//  MapCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/3/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UICollectionViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nearbyCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateMap()
        nearbyCollection.delegate = self
        nearbyCollection.dataSource = self
        
        /*** Register cell nibs ***/
        nearbyCollection.register(UINib.init(nibName: "NearbyCell", bundle: nil), forCellWithReuseIdentifier: "NearbyCell")
        
        UserData.downloadAllUserObjects {
            self.createSortableUsers()
            self.nearbyCollection.reloadData()
        }
    }
    
    func updateMap(){
        if let location = UserManager.shared.currentUser?.currentLocation {
            let distance: Double = 750
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance)
            mapView.setRegion(region, animated: true)
        } else {
            print("Failed to update map")
        }
    }
    
    func createSortableUsers() {
           guard let myLocation = UserManager.shared.currentLocation else { return }
           var tempUsers = [UserAndDistance]()
           for user in UserData.allUserObjects {
               var shell = UserAndDistance()
               shell.user = user
               shell.distanceFromMe = user.currentLocation?.distance(from: myLocation) ?? 0.0
               tempUsers.append(shell)
           }
           UserData.usersSortedByDistance = tempUsers.sorted(by: {$0.distanceFromMe < $1.distanceFromMe})
       }
}


extension MapCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserData.usersSortedByDistance.count == 0 {
            return 5
        } else {
            return UserData.usersSortedByDistance.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = nearbyCollection.dequeueReusableCell(withReuseIdentifier: "NearbyCell", for: indexPath) as! NearbyCell
        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if UserData.usersSortedByDistance.count != 0 {
            let user = UserData.usersSortedByDistance[indexPath.row].user
            cell.loadCell(for: user)
        }
        return cell
    }
    
}
