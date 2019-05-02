//
//  EditProfile.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/14/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase

class EditProfile {
    
    var databaseRef: DatabaseReference?
    let storageRef = Storage.storage().reference()
    
    static func updatePicture(newPicture: UIImage) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else {return}
        
        //Successfully authenticated user.
        let imageName = user?.uid
        let ppStorageRef = Storage.storage().reference().child(imageName!)
        if let uploadData = UIImagePNGRepresentation(newPicture) {
            ppStorageRef.putData(uploadData, metadata: nil, completion:
                
                {( metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    // Fetch the download URL
                    ppStorageRef.downloadURL { url, error in
                        if let error = error {
                            // Handle any errors
                            print(error)
                        } else {
                            // Get the download URL for 'images/stars.jpg'
                            
                            if let profilePictureURL = url?.absoluteString {
                                let values = ["ProfPic": profilePictureURL]
                                //Register into Firebase:
                                DataHandler.updateUserData(uid: uid, values: values)
                                //Register into DataHandler local variables:
                                DataHandler.picURL = profilePictureURL
                                //DataHandler.picture = newPicture
                                DataHandler.picExists = true
                                //Save into defaults.
                                DataHandler.saveDefaults()
                            }
                        }
                    }
                
                    print(metadata!)
            })
        }
    } //End of updating picture
    
}
