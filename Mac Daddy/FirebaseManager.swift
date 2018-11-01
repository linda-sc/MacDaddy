//
//  FirebaseManager.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/4/17.
//  Copyright © 2017 Synestha. All rights reserved.
//
//  No anonymous users!
//  FirebaseManager takes local data from LoginInfo and syncs it to Firebase.

import Foundation
import Firebase
import FirebaseAuth

//Saves login info and sets to user defaults
struct LoginInfo {
    var email:String
    var password:String
    var saved:Bool
    
    
    init(email:String, password:String){
        self.email = email
        self.password = password
        self.saved = true
    }
    
    init(dictionary:[String:String]?){
        
        if dictionary == nil{
            self.email = ""
            self.password = ""
            self.saved = false
        
            return
        }
        
        self.email = dictionary!["email"]!
        self.password = dictionary!["password"]!
        self.saved = true
    }
    
    var dictionary:[String:String]{
        return ["email":self.email, "password":self.password]
    }
}


class FirebaseManager {
//Methods: setup(), linkWithEmailAndPassword(email, password, completion), login(), logout(), sendPasswordReset(), stringFromError(error).
    
    static var isEmailVerified = false
    
    //This function will be called every time the app launches.
    static func setup() {
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        //Enables offline capabilities - this messes up some chat stuff
        //Database.database().isPersistenceEnabled = true
        
        //This listener will trigger whenever the state of the authentication changes.
        //We will use it to track the email verification.
        Auth.auth().addStateDidChangeListener({ (auth:Auth, user:User?) in
            //If the user is linked and verified:
            if let user = user, user.isEmailVerified {
                
                self.isEmailVerified = true
                print("User is verified")
                
            }else{
                print("User not verified")
            }
        })
        
    }
       //We need to store the login info so we can sign the user in automatically the next time they launch the app.
    
    static var loginInfo:LoginInfo?{
        
        set{
            UserDefaults.standard.set(newValue?.dictionary, forKey: "loginInfoKey")
        }
        
        get{
            return LoginInfo.init(dictionary: UserDefaults.standard.dictionary(forKey: "loginInfoKey") as? [String:String])
        }
    }
    
    //We need a local variable to tell us if the user is logged in or not.
    static var isLoggedIn = false
    
    
    //Logout function
    //Log out from the account and don't sign back in automatically until the user signs in again.
    static func logout(){
        print("Logging out.")
        let user = Auth.auth().currentUser
        self.loginInfo?.saved = false
        self.loginInfo = nil
        self.isLoggedIn = false
        try! Auth.auth().signOut()
        
        DataHandler.clearDataHandler()
        DataHandler.clearDefaults()
        
        
        //Delete the account if it's not verified.
        if user?.isEmailVerified == false {
            
            user?.delete { error in
                if let _ = error {
                    print("Error deleting user")
                } else {
                    print("Unverified user successfully deleted")
                }
            }
        }
        
        print(FirebaseManager.loginInfo ?? "No login info saved")
        
    }
    
    static func deleteUnverifiedUser(){
        //Delete the account if it's not verified.
        let user = Auth.auth().currentUser
        if user?.isEmailVerified == false {
            FirebaseManager.loginInfo?.saved = false
            user?.delete { error in
                if let _ = error {
                    print("Error deleting user")
                } else {
                    print("Unverified user successfully deleted")
                }
            }
        }
    }
    
    static func deleteUser(){
        //Delete the account.
        let user = Auth.auth().currentUser
        FirebaseManager.loginInfo?.saved = false
        //Delete user from Auth:
            user?.delete { error in
                if let _ = error {
                    print("Error deleting user")
                } else {
                    print("User successfully deleted")
                }
            }
        //Delete user from database:
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child((user?.uid)!)
        usersReference.removeValue()

    }
    
    
    
    //Password reset function
    //Send reset email to the specified email address
    static func sendPasswordReset(email:String, completion: @escaping(_ Status:Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error:Error?) in
            if error == nil {
                
                completion(true)
                
            }else{
                
                completion(false)
            }
        })
    }
        
    //We need a special function to handle errors returned from Firebase
    static func stringFromError(error:Error?) -> String{
        guard let firebaseError = error as NSError? else {
            return ""
        }
    
        if let errorCode = AuthErrorCode(rawValue: firebaseError.code) {
            switch errorCode {
                
                //Sign in errors
                case .userNotFound:
                    return "Sorry we can't find anyone with this email address! Did you mean to register?"
                case .wrongPassword:
                    return "This password doesn't match your email... Did you forget your password?"
                case .userDisabled:
                    return "You have been banned."
            
                //Registration errors
                case .invalidEmail:
                    return "Make sure you enter a valid email address!"
                case .weakPassword:
                    return "Make sure your password is at least 6 characters!"
                case .emailAlreadyInUse:
                    return "We already have someone registered with this email. Perhaps you meant to sign in?"
                case .accountExistsWithDifferentCredential:
                    return "Hmm something is wrong... Try again?"

                //General error
                default:
                    print("General Error:", error?.localizedDescription ?? "")
                    return "There seems to be a problem... Try again?"
            }
        }
        return ""
    }
}

















