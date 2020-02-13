

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
    
    
    //When app first starts up
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome VC Loaded.")
        
        self.navigationController?.isNavigationBarHidden = true
        background.image = UIImage(named: "MacDaddy Background_DarkMode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 2
        animateLoading{
            //Move the leading bar 1
            self.automaticLogin {
                //Move the loading bar 2
                DataHandler.downloadFriends {
                    //Move the loading bar 3
                    //Set up the observer
                    
                    //First do this
                    for friend in DataHandler.friendList {
                        print("Syncing friend and friendship \(friend.convoID)")
                        FriendshipRequests().upgradeFriendToFriendshipObject(friend: friend)
                    }
                    
                    //Move the loading bar 4
                    FriendshipRequests().observeMyFriendshipObjects {
                        friendships in
                        print("👁 FriendshipObject Observer triggered")
                        NotificationCenter.default.post(name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
                        //UserManager.shared.friendships = friendships
                    }//End of setting up observer
                    
                    FriendshipRequests().downloadMyFriendshipObjects {
                        //Move the loading bar 3
                        friendships in
                        UserManager.shared.friendships = friendships
                         DispatchQueue.main.asyncAfter(deadline: when) {
                             print("👉🏼 WelcomeVC: \(self.segueIdentifier)")
                            self.performSegue(withIdentifier: self.segueIdentifier, sender: Any?.self)
                        }
                    }//End of downloading FriendshipObjects

                    
                    
                }//End of downloading friend structs
            }//End of automatic loading
        }//End of animate loading
    }
    
    //MARK: Animation
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
    
    
    //MARK: Auto Login
    func automaticLogin(completed: @escaping ()-> ()) {
        
        //Firebase login
        let currentUser = Auth.auth().currentUser
        
        //MARK: Case 1: No stored login info
        //If the user is unverified and unsaved, go directly to the login scene.
        if currentUser?.isEmailVerified == false && FirebaseManager.loginInfo?.saved == false {
            //You cannot access the home page without a verified account.
            //Unverified information will not be deleted, but it will not be saved.
            FirebaseManager.loginInfo?.saved = false
            print("🔮 Not logged in")
            self.segueIdentifier = "GoToLogin"
            completed()
            
        //MARK: Case 2: Logged in but unverified
        //If the user is unverified but saved, take them back to the verification page.
        }else if currentUser?.isEmailVerified == false && FirebaseManager.loginInfo?.saved == true {
            print("🔮 Logged in but unverified")
            self.segueIdentifier = "SkipToVerify"
            completed()
        
        //MARK: Case 3: Logged in and verified
        //If the user is logged in with a verified account, skip the verification page.
        }else if currentUser?.isEmailVerified == true && FirebaseManager.loginInfo?.saved == true, let info = FirebaseManager.loginInfo{
            print("🔮 User is saved and verified,")
            print("👉🏼 Automatically logging in")
            //Automatic login process:
            //MARK: Step 1: Firebase login
            Auth.auth().signIn(withEmail: info.email, password: info.password) {
                (user, error) in
                
                //Assign uid to UserObject as soon as you log in.
                //MARK: Step 2: Use Auth UID to pull user data
                UserManager.shared.currentUser?.uid = Auth.auth().currentUser?.uid
                
                //Check that user isn't nil
                if user != nil {
                    print("🙋🏻 User found")
                    
                    let myUid = Auth.auth().currentUser?.uid ?? ""
                    UserRequests().fetchUserObject(userID: myUid, success: { (result) in
                        if let userObject = result as? UserObject {
                             UserManager.shared.currentUser = userObject
                            
                            //Redirect using UserManager
                            if userObject.firstName == nil {
                                self.segueIdentifier = "SkipToNameVC"
                                completed()

                            } else if userObject.avatar == nil {
                                self.segueIdentifier = "SkipToAvatarSetup"
                                completed()

                            }else{
                                self.segueIdentifier = "SkipToHome"
                                completed()
                            }
                            
                        }
                    }) { (error) in
                        self.segueIdentifier = "GoToLogin"
                        completed()
                        print("Couldn't fetch user object.")
                    }
                    
                    
                    //If they haven't finished the setup yet, send them to where they left off.
                    //MARK: Step 3: Take DataHandler snapshot (Deprecated!)
                    DataHandler.checkData {
                        
//                        //If they haven't entered their name yet, sent them to setup1.
//                        if DataHandler.nameExists == false {
//                            print(DataHandler.nameExists)
//                            self.segueIdentifier = "SkipToNameVC"
//                            completed()
//
//                            //If they've entered their name but not their picture, skip to setup2.
////                        }else if DataHandler.picExists == false {
////                            self.segueIdentifier = "skipToSetup2"
////                            completed()
//
//                            //If they've entered their name and picture, skip to setup3.
//                        } else if UserManager.shared.currentUser?.avatar == nil {
//                            self.segueIdentifier = "SkipToAvatarSetup"
//                            completed()
//
//                        }else if DataHandler.gradeExists == false {
//                            self.segueIdentifier = "skipToSetup3"
//                            completed()
//
////                            //If they've entered everything except their interests, skip to setup4.
////                        }else if DataHandler.interestsExist == false {
////                            self.segueIdentifier = "skipToSetup4"
////                            completed()
////
//                            //Otherwise just go to the home screen.
//                        }else{
//                            self.segueIdentifier = "SkipToHome"
//                            completed()
//                        }
                        //If the user is nil somehow, send them back to the login.
                        
                        //Check data also saves our friends into DH as dictionary
                        // Let's convert it into a list while we're loading.
                        
                        DataHandler.friendList = DataHandler.friendDictionaryToList(friends: DataHandler.friends as! [String : [String : String]])
                    }
                
                    
                }else{
                    self.segueIdentifier = "GoToLogin"
                    print("User not found")
                    completed()
                }
            }
            
        }else{
            //MARK: Case 4: Not logged in for some other reason
            //If you're not already logged in, directly segue to the login screen.
            print("Not logged in")
            self.segueIdentifier = "GoToLogin"
            completed()
        }
    }//End of automaticLogin
    
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) {
        print("Unwind to welcome")
    }
    
}//End of class
