//
//  HandleCell.swift
//  Mac Daddy
//
//  Created by Kevin Li on 2/8/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class HandleCell: UICollectionViewCell {

    @IBOutlet weak var vHandleContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func loadForCurrentUser(){
         self.vHandleContentLabel.text = UserManager.shared.currentUser?.vHandle
    }
    
    func loadForUser(user: UserObject) {
        if user.vHandle == nil {
            self.vHandleContentLabel.text = "No Venmo!"
        } else {
            self.vHandleContentLabel.text = user.vHandle
        }
    }
    
}
