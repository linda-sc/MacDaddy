//
//  ChatInterfaceVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/19/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import Firebase

class ChatInterfaceVC: JSQMessagesViewController {

    @IBOutlet weak var background:UIImageView!
    @IBOutlet weak var backButton:UIBarButtonItem!
    @IBOutlet weak var heartButton: UIBarButtonItem!
    
    var messages = [JSQMessage]()
    var friend = Friend()
    
    var friendsRealName = ""
    
    var convoExists = true
    var iSaved = false
    var theySaved = false
    var anon = true
    var friendTyping = false
    
    
    //Message Bubble Colors
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
       // return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        //Bubble color
        if DataHandler.macStatus == "Daddy" {
            //Purple background, hot pink pubbles
           return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: Constants.colors.hotPink)
            
        }else {
            //Mango background, lavender bubbles
            return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: Constants.colors.fadedBlue)
        }

    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        //return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor(red: 0.99, green: 0.6, blue: 0, alpha: 1.00))
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataHandler.updateStatusVariables(active: "y")
        
        convoStillExists {
            if self.convoExists {
                self.addTypingObserver()
                self.addDeletionObserver()
                
                if self.friend.anon == "y" {
                   self.addSavedObserver()
                } else {
                    self.heartButton.tintColor = Constants.colors.hotPink
                }
                
            } else {
                self.showUnfriendAlert()
            }
        }
        
        senderId = DataHandler.uid
        senderDisplayName = DataHandler.name
        self.title = friend.name
        
        print("You are now chatting with \(self.friend)")
        
        inputToolbar.contentView.leftBarButtonItem = nil
        self.collectionView.backgroundView = background
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //Background
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
        }
        
        //Displaying the messages from Firebase
        let query = Constants.refs.databaseConversations.child(friend.convoID).child("chats").queryLimited(toLast: 20)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    
    //Bubble Factory
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    //Hide Avatar Data
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    //Name Label for message bubbles: Either anon or real name
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return NSAttributedString(string: friend.name)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    
    //Sending messages
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        // Because the other user can delete the chat from their end:
        // You can only send messages if the conversation exists.
      
        //This is slow, so let's send the message no matter what, but then retroactively delete the conversation if it was deleted by the other user.
        //If there's no status, that means it was deleted.
        
        let chatsRef = Constants.refs.databaseConversations.child(self.friend.convoID).child("chats").childByAutoId()
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        chatsRef.setValue(message)
        self.finishSendingMessage()
        
        //Also remember what the last chat was:
        let convoRef = Constants.refs.databaseConversations.child(self.friend.convoID)
        convoRef.updateChildValues(["Last Chat": text])
        
        
        convoStillExists {
            if self.convoExists == false {
                //Check AFTER the message has been sent.
                //Your message will still go to Firebase...
                //But it will be deleted immediately if the conversation has ended.
                let currentConvo = Constants.refs.databaseConversations.child(self.friend.convoID)
                currentConvo.removeValue()
                self.showUnfriendAlert()
            }
                
        }//End of closure

    }
}

//All the Firebase stuff:
extension ChatInterfaceVC {
    
    //Remove the in-chat observers when the view is gone.
    override func viewWillDisappear(_ animated: Bool) {
        let convoRef = Database.database().reference().child("conversations").child(friend.convoID).child("status")
        //Remove the observers, otherwise they'll keep firing even if the conversation is gone.
        //You might want to change this later, because you want to listen in for new messages...
        //Actually they should still disappear, and the observers should stick around in HomeVC.
        
        convoRef.removeAllObservers()
    }
    
    func addDeletionObserver() {
        let convoRef = Database.database().reference().child("conversations").child(friend.convoID)
        //Reference the current conversation
        
        convoRef.observe(.childRemoved, with: { snapshot in
            print("ChatInterfaceVC - addObserver: Listener fired")
            //Listener will always be firing to see if this particular convo has been deleted.
        
            self.convoStillExists {
                if self.convoExists == false {
                    self.showUnfriendAlert()
                }//Convo does exist
            }//End of closure
        }) //End of snapshot
    }
    
    
    func addSavedObserver() {
        
        let convoStatusRef = Database.database().reference().child("conversations").child(friend.convoID).child("status")
        
        convoStatusRef.observe(.value, with: { snapshot in
            print("ChatInterfaceVC - addObserver: Listener fired")
                //Listener will always be firing, but nothing will happen if the conversation has been deleted.
            
                self.convoStillExists {
                    if self.convoExists {
                    
                        //Some messy casting to retrieve saved values:
                        let status = snapshot.value as! NSDictionary
                    
                        let myStatus = status[DataHandler.uid!] as! NSDictionary
                        let friendStatus = status[self.friend.uid]! as! NSDictionary
                    
                        let mySavedStatus = myStatus["saved"] as! String
                        let friendSavedStatus = friendStatus["saved"] as! String
                    
                        if (mySavedStatus == "y") {
                            print("I saved the chat, my firebase status is y.")
                            self.heartButton.tintColor = UIColor(red: 0.99, green: 0.24, blue: 0.56, alpha: 1.00)
                            self.iSaved = true
                        } else {
                            self.heartButton.tintColor = UIColor.white
                        }
                        if (friendSavedStatus == "y") {
                            print("They saved the chat!")
                            self.theySaved = true
                        }
                        
                    //This only happens once, when you check and see that both chats are saved:
                    //Might not work, depends on how the code here executes.
                    if (self.iSaved && self.theySaved) {
                        print("Both are saved")
                        //You're friends! Show an alert here.
                        self.anon = false
                        //Change your names in each other's friend lists and update the current friend's name.
                        self.getFriendsRealName {
                            self.showFriendAlert()
                        }
                    }
                }//Convo does exist
            }//End of closure
        }) //End of snapshot
    }
    
    func showFriendAlert() {
        
        //Set up the alert controller
        let message = "Goodbye, \(friend.name)."
        let alert = UIAlertController(title: "Congratulations! You and \(friend.name) both want to be friends.", message: message, preferredStyle: .alert)
        
        // Create the action
        let okAction = UIAlertAction(title: "Hello, \(self.friendsRealName)!", style: UIAlertActionStyle.cancel) {
            
            UIAlertAction in
            self.friend.name = self.friendsRealName
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
            self.dismiss(animated: true, completion: nil)
            //self.performSegue(withIdentifier: "UnwindFromFriendChat", sender: nil)
            print("Goodbye pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Shorter, faster function for just listening to typing:
    func addTypingObserver() {
        let friendTypingRef = Database.database().reference().child("conversations").child(friend.convoID).child("status").child(self.friend.uid).child("typing")
        friendTypingRef.observe(.value, with: { snapshot in
            print("ChatInterfaceVC - addTypingObserver: Listener fired")
            
            if let isTyping = snapshot.value as? String {
                //Now just listen for typing:
                if (isTyping == "y") {
                    self.friendTyping = true
                } else {
                    self.showTypingIndicator = false
                }
            }
        })
    }
    

    func updateTypingStatus() {
    
    }
    
    //Need escaping because for some reason the checking code doesn't execute in order.
    //This code works.
    //Let's change this so that it checks to see if the status exists.
    //If there's no status then it means the other user deleted the conversation.
    
    func convoStillExists(completed: @escaping ()-> ()) {
        if let _ = Auth.auth().currentUser {
            Constants.refs.databaseConversations.child(self.friend.convoID).observeSingleEvent(of: .value, with: { (snapshot) in
                //If the conversation exists then you're good to go.
                //If the snapshot is nil, that's fine, you just know it doesn't exist.
                if snapshot.hasChild("status"){
                    self.convoExists = true
                    completed()
                } else {
                    self.convoExists = false
                    completed()
                }
            }) //End of snapshot
        }//End of if let user condition
    }
    
    func getFriendsRealName(completed: @escaping ()-> ()) {
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(self.friend.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let friend = snapshot.value as? NSDictionary {
                
                self.friendsRealName = friend["Name"] as? String ?? ""
                
                //Now save that name into your friend list in the database:
                
                let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
                let selfRef = ref.child("users").child(DataHandler.uid!)
                let myFriendRef = selfRef.child("Friends").child(self.friend.uid)
                
                let update = ["Name": self.friendsRealName, "Anon": "n"]
                
                myFriendRef.updateChildValues(update)
                print("Name and anon status updated")
                
                
                completed()
            }
        })
    }
    

}

//All the normal stuff:
extension ChatInterfaceVC {
    
    //Use a custom segue here.
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
       // self.performSegue(withIdentifier: "UnwindFromFriendChat", sender: nil)
    }
    
    @IBAction func heartPressed(_ sender: UIBarButtonItem) {
        
        convoStillExists {
            if self.convoExists {
                if (self.friend.anon == "y" && self.iSaved == true) {
                    //If you're still waiting on your match, show an alert.
                    self.showWaitingAlert()
                } else if (self.friend.anon == "y" && self.iSaved == false) {
                    //If you're about to like a new match, show an alert.
                    self.showLikingAlert()
                }
            } else {
                //If the conversation is gone, show that you have been unfriended.
                self.showUnfriendAlert()
            }
        }
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
    
    //Back to the table:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Data in friend array for time and previous message = time and previous message
        //Resort the friend array based on time
        
        if segue.identifier == "UnwindFromFriendChat" {
            
        }
    }
    
}
