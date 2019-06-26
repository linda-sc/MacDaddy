//
//  FriendProfileVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/13/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit

class FriendProfileVC: UIViewController {
    
    var friend = Friend()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Use a custom segue here.
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromFriendDetail", sender: nil)
    }

}
