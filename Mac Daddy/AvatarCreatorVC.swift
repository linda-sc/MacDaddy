//
//  AvatarCreatorVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/14/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class AvatarCreatorVC: UIViewController {
    
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        
        UserManager.shared.currentUser?.avatar = AvatarObject.createRandomAvatar()
        avatarView.avatarObject = UserManager.shared.currentUser?.avatar
        avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //Save avatar to the database
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
