//
//  InputNameVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 10/31/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit
import Firebase

class InputNameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
   var databaseRef: DatabaseReference?
   
   override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.firstNameTextField.autocapitalizationType = .words
        self.lastNameTextField.autocapitalizationType = .words
   }
   
   //Make the status bar white.
   override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
   }
   
   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
   
    
    // MARK: Keyboard

   //Makes the keyboard disappear when you press done.
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
       textField.resignFirstResponder()
       
       self.view.endEditing(true)
       
       var badWordFound = false
       for badWord in Constants.badWords {
           if (self.firstNameTextField.text?.containsIgnoringCase(find: badWord))! {
               badWordFound = true
               showBadWordAlert()
           }
       }
       
    //Display alert if the user correctly filled in their name
       if !badWordFound && isValidName() {
           showAlert()
       }
    
       return false
   }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.topMarginConstraint.constant = 30
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.topMarginConstraint.constant = 100
            UIView.animate(withDuration: 0.3)
            {
                self.view.layoutIfNeeded()
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
       
    // MARK: Alerts

   func showBadWordAlert() {
       let alert = UIAlertController(title: "Hmmm...", message: "That name contains some inappropriate text. Try again.", preferredStyle: .alert)
       let okButton = UIAlertAction(title: "Oops.", style: .default, handler: nil)
       alert.addAction(okButton)
       self.present(alert, animated: true, completion: nil)
   }
       
   func showAlert(){
       let alert = UIAlertController(title: "Hello, " + self.firstNameTextField.text! + ".", message: "Nice to meet you.", preferredStyle: .alert)
       let okButton = UIAlertAction(title: "Nice to meet you too.", style: .default, handler: nil)
       alert.addAction(okButton)
       self.present(alert, animated: true, completion: nil)
   }
       
    // MARK: Next button

    func isValidName() -> Bool {
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        
        var valid = false
        
        if (
            firstName != nil
            && firstName != ""
            && lastName != nil
            && lastName != ""
            ){
            valid = true
        }
        return valid
    }
    
   @IBAction func nextButtonTapped(_ sender:Any){
        print("Next button tapped")
        if isValidName() {
            let firstName = self.firstNameTextField.text
            let lastName = self.lastNameTextField.text
            
            UserManager.shared.currentUser?.firstName = firstName
            UserManager.shared.currentUser?.lastName = lastName
            
            //Legacy stuff
            DataHandler.updateName(name: firstName! + " " + lastName!)
            DataHandler.nameExists = true
            DataHandler.name = firstName! + " " + lastName!
            DataHandler.saveDefaults()
            
            self.performSegue(withIdentifier: "GoToAvatarSetup", sender: self)
            
        } else {
            print("Don't leave your name blank.")
        }
   }

}
