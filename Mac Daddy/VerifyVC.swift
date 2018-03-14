//
//  VerifyVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/4/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class VerifyVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var continueButton:UIButton!
    @IBOutlet weak var loading:UIActivityIndicatorView!
    @IBOutlet weak var didYouClick:UILabel!
    @IBOutlet weak var emailAddress:UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        didYouClick.text = ""
        self.loading.stopAnimating()
        emailAddress.text = Auth.auth().currentUser?.email
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender:UIButton) {
        self.performSegue(withIdentifier: "backToLogin", sender: self)
        FirebaseManager.logout()

    }
    
    @IBAction func continueButtonTapped(_ sender:UIButton) {
        self.didYouClick.text = ""
        self.loading.startAnimating()
        Auth.auth().currentUser?.reload()
        let when = DispatchTime.now() + 1 //seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("Email verification status =")
            print(Auth.auth().currentUser?.isEmailVerified ?? "default")
            
            if (Auth.auth().currentUser?.isEmailVerified) == true {
                DataHandler.updateEmail(email: (Auth.auth().currentUser?.email)!)
                self.performSegue(withIdentifier: "goToSetup", sender: self)
                FirebaseManager.isEmailVerified = true
                
            }else{
                self.didYouClick.text = "Did you click the link in your email? You might have to wait a bit for it to appear."
                self.continueButton.setTitle("I clicked the link!", for: .normal)
                self.loading.stopAnimating()
            }
        }
    }
    
}

