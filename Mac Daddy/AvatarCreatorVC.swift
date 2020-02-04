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
        
        avatarView.avatarObject = UserManager.shared.currentUser?.avatar
        avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //Save avatar to the database
        UserRequests().saveAvatar()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func avatarTapped(_ sender: Any) {
        print("Avatar tapped")
        UserManager.shared.currentUser?.avatar = AvatarObject.createRandomAvatar()
        self.avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
    }
    
    @IBAction func avatarSwiped(_ sender: Any) {
        print("Avatar swiped")
        UserManager.shared.currentUser?.avatar?.changeBaseColor()
        self.avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
    }
    
    @IBAction func avatarPinched(_ sender: Any) {
        print("Avatar pinched")
//        UserManager.shared.currentUser?.avatar?.changeShirt()
//        self.avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
    }
    
    @IBAction func avatarRotated(_ sender: Any) {
        print("Avatar rotated")
    }
    
    
}
