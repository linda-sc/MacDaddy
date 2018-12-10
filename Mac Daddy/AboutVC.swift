//
//  AboutVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 3/12/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }

    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
