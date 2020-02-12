//
//  SponsorsCollectionCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/10/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class SponsorsCollectionCell: UICollectionViewCell {
    
    var parentVC: WorldVC? 
    @IBOutlet weak var sponsorCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sponsorCollection.delegate = self
        sponsorCollection.dataSource = self
        
        /*** Register cell nibs ***/
        sponsorCollection.register(UINib.init(nibName: "SponsorCell", bundle: nil), forCellWithReuseIdentifier: "SponsorCell")
    }

}

extension SponsorsCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sponsorCollection.dequeueReusableCell(withReuseIdentifier: "SponsorCell", for: indexPath) as! SponsorCell
        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = parentVC?.view.bounds.width ?? 300
            let height = parentVC?.view.bounds.height ?? 150
            return CGSize(width: width, height: height)
        }
    
    
}
