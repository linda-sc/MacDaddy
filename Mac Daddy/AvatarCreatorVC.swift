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
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
}
