//
//  LoginVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/23/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signinSelector: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    var isSignin:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
    //Makes the keyboard disappear when you press done.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.view.endEditing(true)
        return false
        // signinButtonTapped(<#T##sender: UIButton##UIButton#>)
        // return true
    }
    
    @IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignin = !isSignin
        //Check the boolean and set the button and labels
        if isSignin
        {
            signinButton.setTitle("Sign In", for: .normal )
        }
        else
        {
            signinButton.setTitle("Register", for: .normal)
        }
    }
    
    func isValidSchoolEmail(email:String) -> Bool{
        return email.hasSuffix("@bc.edu")
        //return true
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
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Check if it's sign in or register
        if isSignin {
            print("Signing in...")
            //Sign in the user with Firebase
            Auth.auth().signIn(withEmail: email!, password: password!) {
                (user, error) in
                
                DataHandler.checkData{}
                
                if error == nil {
                    if FirebaseManager.isEmailVerified{
                        FirebaseManager.isLoggedIn = true
                        FirebaseManager.loginInfo = LoginInfo.init(email:email!, password:password!)
                        
                        self.performSegue(withIdentifier: "goToWelcome", sender: self)
                        print("Successfully logged in with info:")
                        print(FirebaseManager.loginInfo ?? "")
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        //self.progress.stopAnimating()
                        self.showErrorAlert(error: FirebaseManager.stringFromError(error: error))
                    }
                }
            }
            
        //If it's not sign in, it's register.
        } else if isValidSchoolEmail(email: email!) {
            print("Registering...")
            //Register the user with Firebase if the information is valid
                Auth.auth().createUser(withEmail: email!, password: password!) {
                (user, error) in
                
                user?.sendEmailVerification(completion: { (error:Error?) in
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
        }else{
            showErrorAlert(error: "Make sure you use a valid school email.")
        }
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

