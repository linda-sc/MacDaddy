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
    
     @IBOutlet weak var background : UIImageView!
    
    //var messages = [JSQMessage]()
    var friend = Friend()
    var query = DatabaseQuery()
    
    //Message Bubble Colors
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
       // return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        //Bubble color
//        if DataHandler.macStatus == "Daddy" {
//            //Purple background, hot pink pubbles
//           return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: Constants.colors.hotPink)
//
//        }else {
//            //Mango background, lavender bubbles
//            return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: Constants.colors.fadedBlue)
//        }
        
        //Dark mode:
        let lightShadow = "AAB9FF"
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: lightShadow.toRGB())

    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        //return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
//        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor(red: 0.99, green: 0.6, blue: 0, alpha: 1.00))
        let darkShadow = "3F4392"
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: darkShadow.toRGB())
        
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        query.removeAllObservers()
        print("Removing observers")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("🤪 ChatInterfaceVC - ViewWillAppear")
        senderId = DataHandler.uid
        senderDisplayName = DataHandler.name

        print("You are now chatting with \(self.friend)")
        
        inputToolbar.contentView.leftBarButtonItem = nil
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //Background
        self.collectionView.backgroundView = background
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
        }
        background.image = UIImage(named: "MacDaddy Background_DarkMode")
        self.collectionView.backgroundView = background
        
        
        //Displaying the messages from Firebase
        collectionView.reloadData()
        print("🤪 ChatInterfaceVC - Querying and displaying messages from Firebase")
        query = Constants.refs.databaseConversations.child(friend.convoID).child("chats").queryLimited(toLast: 40)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    ChatHandler.messages.append(message)
                    print("Appending message...")
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    //Bubble Factory
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
            //print("Messages array size: \(ChatHandler.messages.count)")
        if ChatHandler.messages.count > indexPath.item {
            return ChatHandler.messages[indexPath.item]
        } else {
            return nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ChatHandler.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return ChatHandler.messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
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
        return ChatHandler.messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    
    //Sending messages
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        // Because the other user can delete the chat from their end:
        // You can only send messages if the conversation exists.
      
        //This is slow, so let's send the message no matter what, but then retroactively delete the conversation if it was deleted by the other user.
        //If there's no status, that means it was deleted.
        
        let chatsRef = Constants.refs.databaseConversations.child(self.friend.convoID).child("chats").childByAutoId()
        let message = ["sender_id": senderId,
                       //IMPORTANT FOR PUSH NOTIFICATIONS
                       "reciever_id": friend.uid,
                       "name": senderDisplayName,
                       "text": text]
        
        chatsRef.setValue(message)
        self.finishSendingMessage()
        
        //Also remember what the last chat was:
        let convoRef = Constants.refs.databaseConversations.child(self.friend.convoID)
        convoRef.updateChildValues(["lastChat": text, "lastChatSenderID": senderId])
    }
    
   
}

