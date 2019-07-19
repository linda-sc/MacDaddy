//
//  InterestCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/18/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {

    @IBOutlet weak var interestIcon: UIImageView!
    @IBOutlet weak var interestField: UILabel!
    @IBOutlet weak var interestName: UILabel!
    @IBOutlet weak var moreIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        moreIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
        let shadeColor = "AAB9FF"
        moreIcon.setImageColor(color: shadeColor.toRGB()!)
        interestIcon.setImageColor(color: shadeColor.toRGB()!)

    }

}
