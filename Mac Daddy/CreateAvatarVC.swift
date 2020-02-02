//
//  CreateAvatarVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/1/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateAvatarVC: UIViewController {

    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        if UserManager.shared.currentUser?.avatar == nil {
            UserManager.shared.currentUser?.avatar = AvatarObject.createRandomAvatar()
        } else {
            self.avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
        }
    }
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        print("Continue tapped.")
        saveAvatar()
        self.performSegue(withIdentifier: "SkipToHome", sender: nil)
    }
    
    @IBAction func avatarTapped(_ sender: Any) {
        print("Avatar tapped.")
       
        UserManager.shared.currentUser?.avatar = AvatarObject.createRandomAvatar()
        self.avatarView.displayAvatar(avatar: UserManager.shared.currentUser?.avatar)
    }
    
    @IBAction func avatarSwiped(_ sender: Any) {
        print("Avatar swiped.")
    }
    
    @IBAction func avatarPinched(_ sender: Any) {
        print("Avatar pinched.")

    }
    
    @IBAction func avatarRotated(_ sender: Any) {
        print("Avatar rotated.")

    }
    
    func saveAvatar(){
        print("SAVING AVATAR:")
        if let currentUser = UserManager.shared.currentUser {
            UserRequests().updateUserInFirestore(userObject: UserManager.shared.currentUser!)
            print(UserManager.shared.currentUser!.avatar)
        } else {
            print("Current user is nil.")
        }
        
    }
    
    
}
