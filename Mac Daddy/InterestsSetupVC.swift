//
//  InterestsSetupVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class InterestsSetupVC: UIViewController {
    
    @IBOutlet weak var background:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background:
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
        }
        
        //If the user is logged in they finished the setup:
        if Auth.auth().currentUser != nil {
            print("Performing finishSetup segue")
            self.performSegue(withIdentifier: "finishSetup", sender: self)
            
        }
        
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
