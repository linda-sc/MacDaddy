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
    @IBOutlet weak var nearbyCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateMap()
        nearbyCollection.delegate = self
        nearbyCollection.dataSource = self
        
        /*** Register cell nibs ***/
        nearbyCollection.register(UINib.init(nibName: "NearbyCell", bundle: nil), forCellWithReuseIdentifier: "NearbyCell")
    }
    
    func updateMap(){
        if let location = UserManager.shared.currentUser?.currentLocation {
            let distance: Double = 750
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = nearbyCollection.dequeueReusableCell(withReuseIdentifier: "NearbyCell", for: indexPath) as! NearbyCell
        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return cell
    }
    
    
    
    
    
}
