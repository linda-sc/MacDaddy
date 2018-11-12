//
//  AboutVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 3/12/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

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
