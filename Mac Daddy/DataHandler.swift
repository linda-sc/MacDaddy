//
//  DataHandler.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//
//  DataHandler syncs data between Firebase, local class variables, and user defaults.
//  Basically a static environment that functions as a local database.

import Foundation
import Firebase

class DataHandler {
    
    //Shortcut variables for storing user information
    static var user = Auth.auth().currentUser
    static var uid = Auth.auth().currentUser?.uid
    static var db = Firestore.firestore()
    static var rtdb = Database.database().reference()
    static var storageRef = Storage.storage().reference()

    //Setup variables
    static var nameExists:Bool = false
    static var picExists:Bool = false
    static var gradeExists:Bool = false
    static var interestsExist:Bool = false
    
    //Profile information saved locally
    static var organization = ""
    static var email = ""
    static var name = ""
    static var macStatus = ""
    static var picURL = ""
    static var grade = ""
    
    //Variables for local matching function
    static var currentMatchID = ""
    static var interests = NSDictionary()
    static var friends = NSDictionary()
    static var friendList = [Friend]()
    static var convos = [Convo]()

    
    //Saves the DataHandler class data to user defaults
    static func saveDefaults(){
        UserDefaults.standard.set(self.name, forKey: "Name")
        UserDefaults.standard.set(self.picURL, forKey: "PicURL")
        UserDefaults.standard.set(self.grade, forKey: "Grade")
        UserDefaults.standard.set(self.macStatus, forKey: "MacStatus")
        UserDefaults.standard.set(self.interests, forKey: "Interests")
        UserDefaults.standard.set(self.friends, forKey: "Friends")
        UserDefaults.standard.set(self.currentMatchID, forKey: "CurrentMatchID")
    }
    
    //Clears the user defaults.
    static func clearDefaults(){
        self.name = ""
        self.picURL = ""
        self.grade = ""
        self.macStatus = ""
        
        self.interests = NSDictionary()
        self.friends = NSDictionary()
        self.currentMatchID = ""
        
        UserDefaults.standard.set("", forKey: "Name")
        UserDefaults.standard.set("", forKey: "PicURL")
        UserDefaults.standard.set("", forKey: "Grade")
        UserDefaults.standard.set("", forKey: "MacStatus")
        UserDefaults.standard.set(NSDictionary(), forKey: "Interests")
        UserDefaults.standard.set(NSDictionary(), forKey: "Friends")
        UserDefaults.standard.set("", forKey: "CurrentMatchID")
    }
    
    //Fetches the class data from the user defaults.
    static func getDefaults() {
        self.name = UserDefaults.standard.string(forKey: "Name") ?? ""
        self.picURL = UserDefaults.standard.string(forKey: "PicURL") ?? ""
        self.grade = UserDefaults.standard.string(forKey: "Grade") ?? ""
        self.macStatus = UserDefaults.standard.string(forKey: "MacStatus") ?? ""
        self.interests = UserDefaults.standard.dictionary(forKey: "Interests")! as NSDictionary
        self.friends = UserDefaults.standard.dictionary(forKey: "Friends")! as NSDictionary
        self.currentMatchID = UserDefaults.standard.string(forKey: "CurrentMatchID") ?? ""
        
        print("Fetching user defaults: \(UserDefaults.standard.string(forKey: "MacStatus") ?? "No Mac Status")")
    }
    
    static func clearDataHandler() {
        user = nil
        uid = nil
        db = Firestore.firestore()
        storageRef = Storage.storage().reference()
        
        nameExists = false
        picExists = false
        gradeExists = false
        interestsExist = false
        
        name = ""
        picURL = ""
        grade = ""
        macStatus = ""
        
        interests = NSDictionary()
        friends = NSDictionary()
        friendList = [Friend]()
        currentMatchID = ""
        convos = [Convo]()
    }

    static func moveVerifiedUserToFirestore(){
        print("👉🏻 Moving verified user to Cloud Firestore...")
        if let refreshUid = Auth.auth().currentUser?.uid {
            db.collection("users").document(refreshUid).setData(["8: Active": "1"]) { err in
                if let err = err {
                    print("Error moving user: \(err)")
                } else {
                    print("User successfully moved!")
                }
                
                //Delete user from RTDB:
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child((user?.uid)!)
                usersReference.removeValue(){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("User could not be deleted in RTDB: \(error).")
                    } else {
                        print("User deleted in RTBD successfully!")
                    }
                }
            }
        } else {
            print("User ID not found.")
        }
    }
    
    //Download the data from Firebase:
    static func checkData(completed: @escaping ()-> ()) {
        
        if let user = Auth.auth().currentUser {
            
            DataHandler.user = user
            DataHandler.uid = user.uid
            
            db.collection("users").document(uid!).getDocument { (document, error) in
                
                    if let document = document, document.exists {
                        
                        print("🔥👀 Checking Firestore Data...")
                        
                        let snapshot = document.data()
                        print("📸 snapshot: \(snapshot ?? [:])")
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                         print("🔥👀 Data: \(dataDescription)")
                        
                        //1. Checks to see whether or not the user has completed setup1 and entered their name.
                        if let name = snapshot?["5: Name"] as? String {
                            if name == "" {
                                self.nameExists = false
                                print("👋🏼 Check Data: Name field is empty")
                            } else {
                                self.nameExists = true
                                self.name = name
                                print("👍🏼 Check Data: Name exists - \(self.name)")
                            }
                        } else {
                            self.nameExists = false
                            print("🤦🏻‍♀️ Check Data: Name field doesn't exist")
                        }
                        
                        
                        //2. Checks to see whether or not the user has completed setup2 and selected a picture.
                        if let picURL = snapshot?["ProfPic"] as? String {
                            
                            if picURL == "" {
                                self.picExists = false
                                print("👋🏼 Check Data: Picture field is empty")
                            } else {
                                self.picExists = true
                                self.picURL = (snapshot?["ProfPic"] as? String)!
                                print("👍🏼 Check Data: Picture exists - \(self.picURL)")
                            }
                        }else{
                            print("🤦🏻‍♀️ Check Data: Picture field doesn't exist")
                            self.picExists = false
                        }
                        
                        //3. Checks to see whether or not the user has completed setup2 and selected a grade.
                        
                        if let grade = snapshot?["9: Grade"] as? String {
                            if grade == "" {
                                self.gradeExists = false
                                print("👋🏼 Check Data: Grade is empty")
                            } else {
                                self.gradeExists = true
                                self.grade = (snapshot?["9: Grade"] as? String)!
                                print("👍🏼 Check Data: Grade exists - \(self.grade)")
                            }
                            
                        } else {
                            self.gradeExists = false
                            print("🤦🏻‍♀️ Check Data: Grade doesn't exist")
                        }
                        
                        //4. Checks to see whether or not the user has completed setup2 and selected a Mac Status.
                        if let macStatus = snapshot?["6: MacStatus"] as? String {
                            if macStatus == "" {
                                self.macStatus = ""
                                print("👋🏼 Check Data: Mac Status is empty")
                            } else {
                                self.macStatus = (snapshot?["6: MacStatus"] as? String)!
                                print("👍🏼 Check Data: Mac Status exists - \(self.macStatus)")
                            }
                            
                        } else {
                            self.macStatus = ""
                            print("🤦🏻‍♀️ Check Data: Mac Status doesn't exist")
                        }
                        
                        
                        //5. Download interests.
                        if let interests = snapshot?["Interests"] as! NSDictionary? {
                            self.interests = interests
                            print("👍🏼 Check Data: Interests exist - \(self.interests)")
                        } else {
                            self.interests = NSDictionary()
                            print("🤦🏻‍♀️ Check Data: Interests don't exist")
                        }
                        
                        //6. Download current match's conversation ID:
                        if let currentMatchID = snapshot?["7: MatchID"] as? String {
                            if currentMatchID == "" {
                                self.currentMatchID = ""
                                print("👋🏼 Check Data: Current match is empty")
                                completed()
                            } else {
                                self.currentMatchID = (snapshot?["7: MatchID"] as? String)!
                                print("👍🏼 Check Data: Current match exists - \(self.currentMatchID)")
                                completed()
                            }
                            
                        } else {
                            self.currentMatchID = ""
                            print("🤦🏻‍♀️ Check Data: Current match doesn't exist")
                            completed()
                            
                        }
                        
                    } else {
                        print("‼️ Data does not exist")
                        completed()
                    }
                
            } //End of Firestore snapshot
        }//End of if let user condition
    }//End of checkData.
}//End of DataHandler
