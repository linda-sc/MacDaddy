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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var sponsors = [
        SponsorObject(uid: "Cqyvv3GNbgdfTmWzOeNLEy8ZVWU2", imageName: "SponsorSample"),
        SponsorObject(uid: "Cqyvv3GNbgdfTmWzOeNLEy8ZVWU2", imageName: "MDTeam")
    ]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView)}

        
        
        sponsorCollection.delegate = self
        sponsorCollection.dataSource = self
        
        /*** Register cell nibs ***/
        sponsorCollection.register(UINib.init(nibName: "SponsorCell", bundle: nil), forCellWithReuseIdentifier: "SponsorCell")
        
        //Set layout
        if let flow = sponsorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
             flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        //let flowLayout = BouncyLayout(style: .prominent)
        self.sponsorCollection.setCollectionViewLayout(flowLayout, animated: true)
    }
}

extension SponsorsCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sponsorCollection.dequeueReusableCell(withReuseIdentifier: "SponsorCell", for: indexPath) as! SponsorCell
            
        let sponsor = sponsors[indexPath.row]
        cell.sponsorImage.image = UIImage(named: sponsor.imageName!)
        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        setStructure(for: cell)
        return cell
    }
    
    private func setStructure(for cell: UICollectionViewCell) {
        cell.layer.borderWidth = 20
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = parentVC?.view.bounds.width ?? 300
            let height = CGFloat(100)
            return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at")
    }
    
}
