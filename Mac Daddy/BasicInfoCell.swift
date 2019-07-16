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
    @IBOutlet weak var nameTag: UILabel!
    @IBOutlet weak var emailTag: UILabel!
    @IBOutlet weak var avatarView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //This is important.
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView)}
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        orgTag.layer.cornerRadius = 12
        orgTag.clipsToBounds = true
        orgTag.text = UserManager.shared.currentUser?.organization
        nameTag.text = UserManager.shared.currentUser?.firstName //Last name not available atm
        emailTag.text = UserManager.shared.currentUser?.email
        //macStatusTag.text = UserManager.shared.currentUser?.status
        //gradeTag.text = UserManager.shared.currentUser?.grade
    }
}
