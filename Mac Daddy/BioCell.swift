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
    }
    
    func loadForCurrentUser(){
         self.shortBioContentLabel.text = UserManager.shared.currentUser?.shortBio
    }
    
    func loadForUser(user: UserObject) {
        if user.shortBio == nil {
            self.shortBioContentLabel.text = "Hello, I'm a beta tester!"
        } else {
            self.shortBioContentLabel.text = user.shortBio
        }
        
    }
}
