

//
//  WelcomeVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/5/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//All the loading and slow Firebase stuff happens here.
class WelcomeVC: UIViewController {
    
    
    @IBOutlet weak var background:UIImageView!
    @IBOutlet weak var loading:UIImageView!
    var segueIdentifier = "NONE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = UIImage(named: "MacDaddy Background_Purple")
        
        let when = DispatchTime.now() + 2
        animateLoading{
            self.automaticLogin {
                DispatchQueue.main.asyncAfter(deadline: when) {
                    print("👉🏼 WelcomeVC: \(self.segueIdentifier)")
                    self.performSegue(withIdentifier: self.segueIdentifier, sender: Any?.self)
                }
            }
        }
        
    }
    
    func animateLoading(completed: @escaping ()-> ()){
        var images = [UIImage]()
        for count in 1...64 {
            let imageName : String = "Loading\(64 - count)"
            let image  = UIImage(named: imageName)
            images.append(image!)
        }
    
        self.loading.animationImages = images;
        self.loading.animationDuration = 2
        self.loading.startAnimating()
        
        completed()
        
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func automaticLogin(completed: @escaping ()-> ()) {
        
        //Firebase login
        let currentUser = Auth.auth().currentUser
        
        //If the user is unverified and unsaved, go directly to the login scene.
        if currentUser?.isEmailVerified == false && FirebaseManager.loginInfo?.saved == false {
            //You cannot access the home page without a verified account.
            //Unverified information will not be deleted, but it will not be saved.
            FirebaseManager.loginInfo?.saved = false
            print("🔮 Not logged in")
            self.segueIdentifier = "👉🏼 goToLogin"
            completed()
            
            //If the user is unverified but saved, take them back to the verification page.
        }else if currentUser?.isEmailVerified == false && FirebaseManager.loginInfo?.saved == true {
            print("🔮 Logged in but unverified")
            self.segueIdentifier = "👉🏼 skipToVerify"
            completed()
            
            //If the user is logged in with a verified account, skip the verification page.
        }else if currentUser?.isEmailVerified == true && FirebaseManager.loginInfo?.saved == true, let info = FirebaseManager.loginInfo{
            print("🔮 User is saved and verified,")
            print("👉🏼 Automatically logging in")
            //Automatic login process:
            Auth.auth().signIn(withEmail: info.email, password: info.password) {
                (user, error) in
                
                //Check that user isn't nil
                if user != nil {
                    print("🙋🏻 User found")
                    
                    //If they haven't finished the setup yet, send them to where they left off.
                    DataHandler.checkData {
                        
                        //If they haven't entered their name yet, sent them to setup1.
                        if DataHandler.nameExists == false {
                            print(DataHandler.nameExists)
                            self.segueIdentifier = "skipToSetup1"
                            completed()
                            
                            //If they've entered their name but not their picture, skip to setup2.
                        }else if DataHandler.picExists == false {
                            self.segueIdentifier = "skipToSetup2"
                            completed()
                            
                            //If they've entered their name and picture, skip to setup3.
                        }else if DataHandler.gradeExists == false {
                            self.segueIdentifier = "skipToSetup3"
                            completed()
                            
                            
                            
//                            //If they've entered everything except their interests, skip to setup4.
//                        }else if DataHandler.interestsExist == false {
//                            self.segueIdentifier = "skipToSetup4"
//                            completed()
//                    
                            
                            
                            //Otherwise just go to the home screen.
                        }else{
                            self.segueIdentifier = "skipToHome"
                            completed()
                        }
                        //If the user is nil somehow, send them back to the login.
                        
                        //Check data also saves our friends into DH as dictionary
                        // Let's convert it into a list while we're loading.
                        
                        DataHandler.friendList = DataHandler.friendDictionaryToList(friends: DataHandler.friends as! [String : [String : String]])
                        
                    }
                    
                }else{
                    self.segueIdentifier = "goToLogin"
                    print("User not found")
                    completed()
                }
            }
            
        }else{
            //If you're not already logged in, directly segue to the login screen.
            print("Not logged in")
            self.segueIdentifier = "goToLogin"
            completed()
        }
    }//End of automaticLogin
    
}//End of class
