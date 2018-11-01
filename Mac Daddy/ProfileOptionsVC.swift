//
//  ProfileOptionsVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileOptionsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var profilePicture:UIImageView!
    @IBOutlet weak var background:UIImageView!
    
    @IBOutlet weak var changeProfilePictureButton: UIButton!
    @IBOutlet weak var editProfileSettingsButton: UIButton!
    @IBOutlet weak var editInterestsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    var databaseRef: DatabaseReference?
    let storageRef = Storage.storage().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format buttons:
        
        //changeProfilePictureButton.layer.borderWidth = 2.0
        changeProfilePictureButton.layer.cornerRadius = 6
        //changeProfilePictureButton.layer.borderColor = UIColor.white.cgColor
        
        //editProfileSettingsButton.layer.borderWidth = 2.0
        editProfileSettingsButton.layer.cornerRadius = 6
        //editProfileSettingsButton.layer.borderColor = UIColor.white.cgColor
        
        //editInterestsButton.layer.borderWidth = 2.0
        editInterestsButton.layer.cornerRadius = 6
        //editInterestsButton.layer.borderColor = UIColor.white.cgColor
  
        //logOutButton.layer.borderWidth = 2.0
        logOutButton.layer.cornerRadius = 6
        //logOutButton.layer.borderColor = UIColor.white.cgColor
        
        profilePicture.layer.borderWidth = 4.0
        //profilePicture.layer.borderColor = UIColor.white.cgColor
  
        //Set background:
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            changeProfilePictureButton.backgroundColor = Constants.colors.neonCarrot
            editProfileSettingsButton.backgroundColor = Constants.colors.neonCarrot
            editInterestsButton.backgroundColor = Constants.colors.neonCarrot
            logOutButton.layer.borderColor = Constants.colors.neonCarrot.cgColor
            profilePicture.layer.borderColor = Constants.colors.neonCarrot.cgColor
            logOutButton.layer.backgroundColor = Constants.colors.hotPink.cgColor
        }else {
            background.image = UIImage(named: "MacDaddy Background")
            changeProfilePictureButton.backgroundColor = Constants.colors.fadedBlue
            editProfileSettingsButton.backgroundColor = Constants.colors.fadedBlue
            editInterestsButton.backgroundColor = Constants.colors.fadedBlue
            logOutButton.layer.borderColor = Constants.colors.fadedBlue.cgColor
            profilePicture.layer.borderColor = Constants.colors.fadedBlue.cgColor
            logOutButton.layer.backgroundColor = Constants.colors.neonCarrot.cgColor
        }
        
        nameLabel.text = DataHandler.name
        
            //Fetch the picture data.
            let picURL = DataHandler.picURL
            let url = NSURL(string: picURL)
            let request = URLRequest(url: url! as URL)
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    self.profilePicture.image = UIImage(data: data!)
                })
            } .resume()
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backToHomeTapped(_ sender:UIButton) {
        self.performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    @IBAction func editPreferencesTapped(_ sender:UIButton) {
        self.performSegue(withIdentifier: "goToPreferences", sender: self)
    }
    
    @IBAction func editInterestsTapped(_ sender:UIButton) {
            //Feature is not ready yet.
        let alert = UIAlertController(title: "Coming soon...", message: "We are still working on this feature!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "I'm hyped.", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender:UIButton){
        FirebaseManager.logout()
        print("Logging out...")
        self.performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    
    @IBAction func aboutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showAbout", sender: self)
    }
    
    //Editing your profile picture:
    @IBAction func changePictureTapped(_sender:UIButton){
        //Create instance of image picker controller.
        let picker = UIImagePickerController()
        //Set delegate.
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
    }
    
    //What happens when the user selects a photo?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Create a holder variable for the image.
        var chosenImage = UIImage()
        //Save the image onto the variable.
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            chosenImage = editedImage as! UIImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            chosenImage = originalImage as! UIImage
        }
        //Update the image view.
        profilePicture.image = chosenImage
        //Dismiss the picker.
        EditProfile.updatePicture(newPicture: self.profilePicture.image!)
        dismiss(animated: true, completion: nil)
    }
    
    //What happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
}
