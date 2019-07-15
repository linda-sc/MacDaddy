//
//  MapCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/3/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class MapCell: UICollectionViewCell {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateMap()
    }
    
    func updateMap(){
        if let location = UserManager.shared.currentUser?.currentLocation {
            let distance: Double = 750
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance)
            mapView.setRegion(region, animated: true)
        }
    }

}
