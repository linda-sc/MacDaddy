//
//  BasicInfoCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/24/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class BasicInfoCell: UICollectionViewCell {
 
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var orgTag: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //This is important.
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView)}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePicture.layer.cornerRadius = 20
        profilePicture.clipsToBounds = true
        orgTag.layer.cornerRadius = 12
        orgTag.clipsToBounds = true
    }
}
