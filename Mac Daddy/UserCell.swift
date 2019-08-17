//
//  UserCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 8/17/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {

    @IBOutlet weak var avatar: AvatarView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var user: Friend?
    var userObject: UserObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
