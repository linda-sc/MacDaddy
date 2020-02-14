//
//  SponsorCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/10/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class SponsorCell: UICollectionViewCell {
    
    @IBOutlet weak var sponsorImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //This is important.
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView)}
        
        imageHeight.constant = 200
        imageWidth.constant = 200
    }

}
