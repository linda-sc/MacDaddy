//
//  BioCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/24/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class BioCell: UICollectionViewCell {

    @IBOutlet weak var shortBioContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shortBioContentLabel.text = UserManager.shared.currentUser?.shortBio
        self.shortBioContentLabel.text = DataHandler.shortBio
    }
}
