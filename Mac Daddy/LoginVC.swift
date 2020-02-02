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
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var termsLabelHeight: NSLayoutConstraint!
    
    var isSignin:Bool = true
    var termsAgreed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        termsLabel.isHidden = true
        checkmarkButton.isHidden = true
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
    
    // MARK: Keyboard
    
    //Makes the keyboard disappear when you press done.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.logoTopConstraint.constant = 10
        self.logoHeight.constant = 40
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.logoTopConstraint.constant = 30
        self.logoHeight.constant = 120
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func checkmarkButtonTapped(_ sender: Any) {
        termsAgreed = !termsAgreed
        if termsAgreed {
            checkmarkButton.setBackgroundImage(UIImage(named: "ActiveBubble"), for: .normal)
        } else {
            checkmarkButton.setBackgroundImage(UIImage(named: "RedBubble"), for: .normal)
        }
    }
    
    
    // MARK: Selector
    @IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignin = !isSignin
        //Check the boolean and set the button and labels
        if isSignin
        {
            signinButton.setTitle("Sign In", for: .normal )
            termsLabel.isHidden = true
            checkmarkButton.isHidden = true
            termsLabelHeight.constant = 0
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            signinButton.setTitle("Register", for: .normal)
            termsLabel.isHidden = false
            checkmarkButton.isHidden = false
            termsLabelHeight.constant = 30
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Email check
    func isValidEmail(email:String) -> Bool{
        var valid = false
        
//        if  email.hasSuffix("@bc.edu")
//            || email.hasSuffix("@gmail.com")
//            || email.hasSuffix("@cornell.edu")
        
        if email.contains(find: "@")
            && email.contains(find: ".")
        {
            valid = true
        }
        return valid
    }
    
    // MARK: Error alerts
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
    
    
    // MARK: Sign In
    func signIn() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Check if it's sign in or register
        if isSignin {
            print("Signing in...")
            //Sign in the user with Firebase
            Auth.auth().signIn(withEmail: email!, password: password!) {
                
                (user, error) in
                
                //Assign uid to UserObject as soon as you log in.
                UserManager.shared.currentUser?.uid = Auth.auth().currentUser?.uid
                
                //Sync everything up from Firebase
                DataHandler.checkData{}
                
                if error == nil {
                    if FirebaseManager.isEmailVerified{
                        
                        FirebaseManager.isLoggedIn = true
                        FirebaseManager.loginInfo = LoginInfo.init(email:email!, password:password!)
                        
                        //self.performSegue(withIdentifier: "goToWelcome", sender: self)
                        self.performSegue(withIdentifier: "UnwindToWelcome", sender: nil)
                        
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
        } else if isValidEmail(email: email!) && termsAgreed{
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
                    self.performSegue(withIdentifier: "GoToVerify", sender:nil)
                    FirebaseManager.isLoggedIn = true
                    FirebaseManager.loginInfo = LoginInfo.init(email:email!, password:password!)
                    FirebaseManager.loginInfo?.saved = false
                    UserManager.shared.currentUser?.email = email!

                    print("Unverified account created")
                    
                }else{
                    DispatchQueue.main.async {
                        //self.progress.stopAnimating()
                        self.showErrorAlert(error: FirebaseManager.stringFromError(error: error))
                    }
                }
            }
        }else if !isValidEmail(email: email!) {
            showErrorAlert(error: "Make sure you use a valid email address.")
        } else if !termsAgreed {
            showErrorAlert(error: "Please agree to the privacy policy.")
        }
    }
    
    
    // MARK: Buttons
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func forgotPasswordTapped(_ sender:UIButton){
        if self.emailTextField.text == "" {
            showErrorAlert(error: "Enter your email so we can send you a link to reset your password.")
            
        }else if !isValidEmail(email:self.emailTextField.text!) {
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

