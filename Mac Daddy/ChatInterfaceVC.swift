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
    
    
    ////////////////////////////////////////////
    /////////  UPDATE FOR FIRESTORE  ///////////
    ////////////////////////////////////////////
    
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

    }
    
   
}

