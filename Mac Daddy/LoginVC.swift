//
//  LoginVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/23/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signinSelector: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var termsStack: UIStackView!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var isSignin:Bool = true
    var termsAgreed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        termsStack.isHidden = true
        checkmarkButton.setBackgroundImage(UIImage(named: "RedBubble"), for: .normal)
        
        self.emailTextField.delegate = self
        self.emailTextField.tag = 0
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 1
        
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //Makes the keyboard disappear when you press done.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func checkmarkButtonTapped(_ sender: Any) {
        termsAgreed = !termsAgreed
        if termsAgreed {
            checkmarkButton.setBackgroundImage(UIImage(named: "ActiveBubble"), for: .normal)
        } else {
            checkmarkButton.setBackgroundImage(UIImage(named: "RedBubble"), for: .normal)
        }
    }
    @IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignin = !isSignin
        //Check the boolean and set the button and labels
        if isSignin
        {
            signinButton.setTitle("Sign In", for: .normal )
            termsStack.isHidden = true
        }
        else
        {
            signinButton.setTitle("Register", for: .normal)
            termsStack.isHidden = false
        }
    }
    
    func isValidSchoolEmail(email:String) -> Bool{
        var valid = false
        if  email.hasSuffix("@bc.edu")
            || email.hasSuffix("@besst.io") {
            valid = true
        }
        return valid
    }
    
    func showErrorAlert(error:String){
        let alert = UIAlertController(title: "Try again?", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCustomAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay!", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func signIn() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Check if it's sign in or register
        if isSignin {
            print("Signing in...")
            //Sign in the user with Firebase
            Auth.auth().signIn(withEmail: email!, password: password!) {
                (user, error) in
                
                //Sync everything up from Firebase
                DataHandler.checkData{}
                
                if error == nil {
                    if FirebaseManager.isEmailVerified{
                        FirebaseManager.isLoggedIn = true
                        FirebaseManager.loginInfo = LoginInfo.init(email:email!, password:password!)
                        
                        self.performSegue(withIdentifier: "goToWelcome", sender: self)
                        print("👩🏻‍💻 Successfully logged in with info:")
                        print(FirebaseManager.loginInfo?.email ?? "Email not found")
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        //self.progress.stopAnimating()
                        self.showErrorAlert(error: FirebaseManager.stringFromError(error: error))
                    }
                }
            }
            
            //If it's not sign in, it's register.
        } else if isValidSchoolEmail(email: email!) && termsAgreed{
            print("Registering...")
            //Register the user with Firebase if the information is valid
            Auth.auth().createUser(withEmail: email!, password: password!) {
                (user, error) in
                
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error:Error?) in
                    if error == nil{
                        print("Verification email sent!")
                    }
                })
                
                if error == nil {
                    self.performSegue(withIdentifier: "goToVerify", sender:nil)
                    FirebaseManager.isLoggedIn = true
                    FirebaseManager.loginInfo = LoginInfo.init(email:email!, password:password!)
                    FirebaseManager.loginInfo?.saved = false
                    print("Unverified account created")
                    
                }else{
                    DispatchQueue.main.async {
                        //self.progress.stopAnimating()
                        self.showErrorAlert(error: FirebaseManager.stringFromError(error: error))
                    }
                }
            }
        }else if !isValidSchoolEmail(email: email!) {
            showErrorAlert(error: "Make sure you use a valid school email.")
        } else if !termsAgreed {
            showErrorAlert(error: "Please agree to the privacy policy.")
        }
    }
    
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func forgotPasswordTapped(_ sender:UIButton){
        if self.emailTextField.text == "" {
            showErrorAlert(error: "Enter your email so we can send you a link to reset your password.")
            
        }else if !isValidSchoolEmail(email:self.emailTextField.text!) {
            showErrorAlert(error: "Enter your school email so we can sent you a password reset link.")
            
        }else{
            FirebaseManager.sendPasswordReset(email: self.emailTextField.text!, completion:{ (status:Bool) in
                DispatchQueue.main.async {
                    self.showCustomAlert(title: "Password reset email sent!", message: "Check your email for a password reset link.")
                }
            })
        }
    }
}

