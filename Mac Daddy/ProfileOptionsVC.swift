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
        profilePicture.isHidden = true
        
        // Format buttons:
        
        //changeProfilePictureButton.layer.borderWidth = 2.0
        //changeProfilePictureButton.layer.borderColor = UIColor.white.cgColor
        changeProfilePictureButton.layer.cornerRadius = 20
        changeProfilePictureButton.clipsToBounds = true
        changeProfilePictureButton.setTitle("Show screenshot to developer", for: .normal)

        editProfileSettingsButton.layer.cornerRadius = 20
        editProfileSettingsButton.clipsToBounds = true
        
        editInterestsButton.layer.cornerRadius = 20
        editInterestsButton.clipsToBounds = true
  
        logOutButton.layer.cornerRadius = 20
        logOutButton.clipsToBounds = true
        
        profilePicture.layer.borderWidth = 0
  
        //Set background:
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            changeProfilePictureButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Flipped"), for: .normal)
            editProfileSettingsButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Flipped"), for: .normal)
            editInterestsButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Flipped"), for: .normal)
            logOutButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Purple_Flipped"), for: .normal)
        }else {
            background.image = UIImage(named: "MacDaddy Background")
            changeProfilePictureButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Purple_Flipped"), for: .normal)
            editProfileSettingsButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Purple_Flipped"), for: .normal)
            editInterestsButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Purple_Flipped"), for: .normal)
            logOutButton.setBackgroundImage(UIImage(named: "MacDaddy Background_Flipped"), for: .normal)
        }
        
        nameLabel.text = DataHandler.name
        
            //Fetch the picture data.
            let picURL = DataHandler.picURL
            let url = NSURL(string: picURL)
            let request = URLRequest(url: url! as URL)
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    //self.profilePicture.image = UIImage(data: data!)
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
        let alert = UIAlertController(title: "Coming soon", message: "Still working on this feature", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok.", style: .default, handler: nil)
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
        profilePicture.isHidden = false
        changeProfilePictureButton.setTitle("Screenshot shared!", for: .normal)
        EditProfile.updatePicture(newPicture: self.profilePicture.image!)
        dismiss(animated: true, completion: nil)
    }
    
    //What happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
}
