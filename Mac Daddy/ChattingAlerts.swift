//
//  ChattingAlerts.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/17/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation

//All the alert controller stuff:
extension ChatSceneVC {
    
    func showFriendAlert() {
        
        //Set up the alert controller
        let message = "Goodbye, \(friend.name)."
        let alert = UIAlertController(title: "Congratulations! You and \(friend.name) both want to be friends.", message: message, preferredStyle: .alert)
        
        // Create the action
        let okAction = UIAlertAction(title: "Hello, \(self.friendsRealName)!", style: UIAlertActionStyle.cancel) {
            
            UIAlertAction in
            self.friend.name = self.friendsRealName
            self.friend.anon = "0"
            self.title = self.friendsRealName
            print("Accept pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUnfriendAlert() {
        
        //Set up the alert controller
        let message = "\(friend.name) has ended the conversation."
        let alert = UIAlertController(title: "Don't take it personally.", message: message, preferredStyle: .alert)
        
        // Create the action
        let okAction = UIAlertAction(title: "Goodbye, \(friend.name).", style: UIAlertActionStyle.cancel) {
            
            UIAlertAction in
            //self.dismiss(animated: true, completion: nil)
            //self.performSegue(withIdentifier: "UnwindFromFriendChat", sender: nil)
            self.navigationController?.popViewController(animated: true)
            print("Goodbye pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showLikingAlert() {
        
        //Set up the alert controller
        let message = "\(friend.name) will not be able to see that you have liked them until they have liked you back. If you both like each other, you will no longer be anonymous."
        let alert = UIAlertController(title: "Do you want to be friends with \(friend.name)?", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes, I want to be friends!", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            Matching.saveCurrentMatch(friend:self.friend)
            print("Like pressed")
        }
        
        let cancelAction = UIAlertAction(title: "No, I want to stay anonymous.", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWaitingAlert() {
        
        //Set up the alert controller
        let message = "Keep chatting until they are ready to be friends! Don't worry, they won't know that you've liked them until they like you too."
        let alert = UIAlertController(title: "\(friend.name) still wants to be anonymous.", message: message, preferredStyle: .alert)
        
        // Create the action
        let okAction = UIAlertAction(title: "Ok, got it.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
//    //Back to the table:
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //Data in friend array for time and previous message = time and previous message
//        //Resort the friend array based on time
//
//        if segue.identifier == "UnwindFromFriendChat" {
//
//        }
//    }
    
}
