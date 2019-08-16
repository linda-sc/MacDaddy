//
//  FriendProfileVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/13/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit

class FriendDetailVC: UIViewController {
    
    var friend = Friend()
    var friendObject = UserObject()
    var reportText = ""
    
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var friendPicture: UIImageView!
    @IBOutlet weak var activeBubble: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var tabBarBackground: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ChatHandler.messages = [JSQMessage]()
        
        friendButton.setTitle(friend.name, for: .normal)
        if (friend.active == "1") {
            activeBubble.isHidden = false
        } else {
            activeBubble.isHidden = true
        }
        
        //If the friend is anonymous, use one of the default pictures.
        //We haven't implemented pictures yet so let's just leave it like this.
        //if friend.anon == "1" {
        if true {
            if friend.macStatus == "Daddy" {
                friendPicture.image = UIImage(named: "MacDaddyLogo_Purple")
            } else {
                friendPicture.image = UIImage(named: "MacDaddyLogo")
            }
        }
        
        DataHandler.updateActive(active: "1")
        
        
        //Background
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            tabBarBackground.image = UIImage(named: "TabBar_Purple")?.alpha(0.5)
            
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
            tabBarBackground.image = UIImage(named: "TabBar")?.alpha(0.5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Using a closure function with error handling.
        //The "result" is the success result returned from the function
        //If the result is in, then set the friendObject to the downloaded object.
        //Otherwise, throw an error.
        UserRequests().fetchUserObject(userID: friend.uid, success: { (result) in
            if let userObject = result as? UserObject {
                self.friendObject = userObject
            }
        }) { (error) in
            print("Couldn't fetch user object.")
        }
    }

    //Use a custom segue here.
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromFriendDetail", sender: nil)
    }
    
    
    //BLOCKING AND REPORTING
    @IBAction func displayActionSheet(_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let unmatchAction = UIAlertAction(title: "Unmatch", style: .default) {
            UIAlertAction in
            self.presentUnmatchAlert()
        }
        
        let blockAction = UIAlertAction(title: "Block & Report", style: .default) {
            UIAlertAction in
            self.presentBlockAlert()
        }
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(unmatchAction)
        optionMenu.addAction(blockAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func presentUnmatchAlert() {
        
        //COPIED AND PASTED FROM HOMEVC.
        //Take out the word "Anonymous"
        var nickname = ""
        
        if friend.anon == "1" {
            nickname = friend.name.substring(from: 10)
        } else {
            nickname = friend.name
        }
        
        //Set up the alert controller
        let message = "You are about to end your conversation with \(friend.name)."
        let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        
        // Create the actions
        //Delete a friend: could be your current match, an incoming match, or a friend
        let okAction = UIAlertAction(title: "Goodbye, \(nickname).", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            print("Goodbye pressed")
            
            let isAnon = (self.friend.anon == "1")
            
            //First just delete them normally
            DataHandler.deleteFriend(friend: self.friend, anon: isAnon)
            
            //If that was your current match, take it out, and remove your current match ID.
            if self.friend.uid == DataHandler.currentMatchID {
                DataHandler.updateCurrentMatchID(currentMatchID: "")
                print("Deleting current match")
            } else if isAnon {
                //Else, if you were THEIR current match, remove their current match ID.
                //Any anonymous friend that is not your current match must be an incoming match
                 DataHandler.updateUserData(uid: self.friend.uid, values: ["7: MatchID": ""])
                print("Deleting incoming match")
            }
            
            self.performSegue(withIdentifier: "unwindFromBlock", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "No, I like \(nickname).", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentBlockAlert() {
        //COPIED AND PASTED FROM HOMEVC.
        //Take out the word "Anonymous"
        var nickname = ""
        
        if friend.anon == "1" {
            nickname = friend.name.substring(from: 10)
        } else {
            nickname = friend.name
        }
        
        //Set up the alert controller
        let message = "You are about to block \(friend.name). Help us keep Mac Daddy safe by telling us why you are blocking this user. Don't worry, you will remain completely anonymous."
        
        let alert = UIAlertController(title: "Is there something wrong?", message: message, preferredStyle: .alert)
        
        let problem1 = UIAlertAction(title: "\(nickname) is being inappropriate.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "Inappropriate"
            self.presentblockConfirmationAlert()
        }
        let problem2 = UIAlertAction(title: "Abusive or threatening behavior.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "Abusive"
            self.presentblockConfirmationAlert()
        }
        let problem3 = UIAlertAction(title: "Fraud, spam, or scam.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "Fraud"
            self.presentblockConfirmationAlert()
        }
        let problem4 = UIAlertAction(title: "I just don't like \(nickname).", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "None"
            self.presentblockConfirmationAlert()
        }
        
        let cancelAction = UIAlertAction(title: "Never mind.", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(problem1)
        alert.addAction(problem2)
        alert.addAction(problem3)
        alert.addAction(problem4)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentblockConfirmationAlert() {
        DataHandler.blockFriend(friend: friend, report: reportText)
        
        let message = "This user has been blocked."
        let alert = UIAlertController(title: "Thanks for your feedback.", message: message, preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "unwindFromBlock", sender: self)
        }
        
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
