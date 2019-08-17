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
    }
    
    func loadForCurrentUser() {
        orgTag.text = UserManager.shared.currentUser?.organization
        nameTag.text = UserManager.shared.currentUser?.firstName //Last name not available atm
        emailTag.text = UserManager.shared.currentUser?.email
    }
    
    func loadForUser(friend: Friend, userObject: UserObject) {
        //Friend name
        nameTag.text = friend.name
        
        //Email
        if friend.anon == "1" {
            emailTag.text = "???"
        } else {
            emailTag.text = friend.email
        }
        
        //Organization
        if userObject.organization == nil {
            //All blank user objects represent old users who are all BC students.
            orgTag.text = "Boston College"
        } else {
            orgTag.text = userObject.organization
        }
    }
}
