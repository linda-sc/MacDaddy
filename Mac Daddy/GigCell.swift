//
//  GigCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/1/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class GigCell: UICollectionViewCell {
    
    var parentVC: WorldVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func formatCell(gig: GigObject) {
        self.emailLabel.text = UserRequests().hideEmail(email: gig.email ?? "???")
        self.textLabel.text = gig.text
        self.dateLabel.text = gig.timeStamp?.getElapsedInterval()
    }
    
}
