//
//  MessageInterfaceVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/23/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import MessageKit
import Firebase
import Photos

class MessageInterfaceVC: MessagesViewController {

    
    var friend = Friend()
    var query = DatabaseQuery()
    
    private var messages: [Message] = []
    
    let lightShadow = "AAB9FF"
    let darkShadow = "3F4392"
    
    override func viewDidLoad() {
        //background.image = UIImage(named: "MacDaddy Background_DarkMode")
        setUpLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         query.removeAllObservers() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = UserManager.shared.currentUser {
            let testMessage = Message(user: user, content: "Hello!")
            insertNewMessage(testMessage)
        }
        queryChats()
    }
    
    func setUpLayout(){
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
        }
        
        extendedLayoutIncludesOpaqueBars = true
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = darkShadow.toRGB()
        messageInputBar.sendButton.setTitleColor(darkShadow.toRGB(), for: .normal)
        messageInputBar.becomeFirstResponder()
        
        messageInputBar.delegate = self
        messageInputBar.isHidden = false
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.isHidden = false
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        
    }
    
    func queryChats() {
        query = Constants.refs.databaseConversations.child(friend.convoID).child("chats").queryLimited(toLast: 40)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in

            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                let message = Message(id: id, name: name, content: text)
                self?.messages.append(message)
                print("Message: \(message.content)")
                self?.messagesCollectionView.reloadData()
            }
        })
    }
    
    private func insertNewMessage(_ message: Message) {
      guard !messages.contains(message) else {return}
      messages.append(message)
      messages.sort()
      
      let isLatestMessage = messages.index(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        //let shouldScrollToBottom = isLatestMessage
      
      messagesCollectionView.reloadData()
      
      if shouldScrollToBottom {
        DispatchQueue.main.async {
          self.messagesCollectionView.scrollToBottom(animated: true)
        }
      }
    }
    
    func sendMessage(senderId: String, senderDisplayName: String, text: String){
        // Because the other user can delete the chat from their end:
        // You can only send messages if the conversation exists.
        //
        //This is slow, so let's send the message no matter what, but then retroactively delete the conversation if it was deleted by the other user.
        //If there's no status, that means it was deleted.
        //
        let chatsRef = Constants.refs.databaseConversations.child(self.friend.convoID).child("chats").childByAutoId()
        let message = ["sender_id": senderId,
                               //IMPORTANT FOR PUSH NOTIFICATIONS
                               "reciever_id": friend.uid,
                               "name": senderDisplayName,
                               "text": text]
        
        chatsRef.setValue(message)
        //self.finishSendingMessage()
        
        //Also remember what the last chat was:
        let convoRef = Constants.refs.databaseConversations.child(self.friend.convoID)
        convoRef.updateChildValues(["lastChat": text, "lastChatSenderID": senderId])
    }
}


// MARK: - MessagesDisplayDelegate

extension MessageInterfaceVC: MessagesDisplayDelegate {
  
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? darkShadow.toRGB()! : lightShadow.toRGB()!
    }
  
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
  
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        //let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(.bottomLeft, .curved)
    }
}


// MARK: - MessagesLayoutDelegate

extension MessageInterfaceVC: MessagesLayoutDelegate {
  
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
  
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
  
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}


// MARK: - MessagesDataSource

extension MessageInterfaceVC: MessagesDataSource {

    func currentSender() -> SenderType {
        let user = UserManager.shared.currentUser
        return Sender(id: user!.uid!, displayName: user?.fullName ?? user?.firstName ?? "Me")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
  
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
  
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
  
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
  
}


// MARK: - MessageInputBarDelegate

extension MessageInterfaceVC: MessageInputBarDelegate {
  
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        print("Did press send")
        inputBar.inputTextView.text = ""
    }
  
}
