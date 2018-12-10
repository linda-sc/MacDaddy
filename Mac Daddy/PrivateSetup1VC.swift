//
//  PrivateSetup1VC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/7/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class PrivateSetup1VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField:UITextField!
    var databaseRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.nameTextField.autocapitalizationType = .words
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Makes the keyboard disappear when you press done.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.view.endEditing(true)
        
        var badWordFound = false
        for badWord in Constants.badWords {
            if (self.nameTextField.text?.containsIgnoringCase(find: badWord))! {
                badWordFound = true
                showBadWordAlert()
            }
        }
        
        if !badWordFound {
            showAlert()
        }
        return false
    }
    
    func showBadWordAlert() {
        let alert = UIAlertController(title: "Hmmm...", message: "That name contains some inapprorpriate text. Try again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Oops.", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Hey, " + self.nameTextField.text! + "!", message: "For safety reasons, you can't change your name after this. Make sure this is the name you want to go by.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok, got it.", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender:Any){
        let newName = nameTextField.text
        if newName != "" {
            DataHandler.updateName(name: newName!)
            DataHandler.nameExists = true
            DataHandler.name = newName!
            DataHandler.saveDefaults()
            //Save the new name to both the data handler and the user defaults.
            
            self.performSegue(withIdentifier: "goToSetup3", sender: self)
        }else{
            print("Come on, don't leave your name blank...")
        }
    }
}
