//
//  PrivateSetup2VC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/18/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PrivateSetup2VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var databaseRef: DatabaseReference?
    let storageRef = Storage.storage().reference()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var profilePicture:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        
        //Get the name from the DataHandler
        self.nameLabel.text = DataHandler.name
        //To double check:
         
    }

    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonTapped(_ sender:Any){
        EditProfile.updatePicture(newPicture: self.profilePicture.image!)
        self.performSegue(withIdentifier: "goToSetup3", sender: self)
    }
    

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
        dismiss(animated: true, completion: nil)
    }
    
    
    //What happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //Prepare for the segue to Preferences:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToSetup3" {
            //let destination = segue.destination as! PreferencesSetupVC
            //destination.profilePicture.image = self.profilePicture.image
        }
    }
}

