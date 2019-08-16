//
//  GradeStatusCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/16/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class GradeStatusCell: UICollectionViewCell {

    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradeLabel.text = UserManager.shared.currentUser?.grade?.lowercased()
        if (UserManager.shared.currentUser?.status == "Daddy") {

            statusLabel.text = "looking to feed another student."
        } else {
            statusLabel.text = "looking for a meal."
        }
    }
}
