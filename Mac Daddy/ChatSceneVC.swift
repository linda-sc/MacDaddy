//
//  ChatSceneVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/3/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit
import Foundation
//import MessageKit
import JSQMessagesViewController

class ChatSceneVC: UIViewController {
   
    
    @IBOutlet weak var background:UIImageView!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var tabBarBackground: UIImageView!
    @IBOutlet weak var profileBar: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var activeBubble: UIImageView!
    @IBOutlet weak var avatarView: AvatarView!
    
    var friend = Friend()
    var friendship = FriendshipObject()
    var userObject = UserObject()
    var friendsRealName = ""
    
    var convoExists = true
    var iSaved = false
    var theySaved = false
    var anon = true
    var friendTyping = false
    
    //Embed the ChatInterfaceVC inside the scene:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedChatSegue" {
            
//            if let childVC = segue.destination as? MessageInterfaceVC {
//                           //Some property on ChildVC that needs to be set
//                           childVC.friend = self.friend
//                           //ChatHandler.messages = [Message]()
//                       }
            
            if let childVC = segue.destination as? ChatInterfaceVC {
                //Some property on ChildVC that needs to be set
                childVC.friend = self.friend
                childVC.friendship = self.friendship
                ChatHandler.messages = [JSQMessage]()
            }
        } else if segue.identifier == "showFriendDetail" {
                let destination = segue.destination as! FriendDetailVC
                destination.friend = self.friend
                destination.friendship = self.friendship
                destination.userObject = self.userObject
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (friend.anon == "1") {
            anon = true
        } else {
            anon = false
        }
        
    }
    
    override func viewDidLoad() {
        print("🤪 ChatScene VC - ViewDidLoad")
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        var avatar: AvatarObject?
        if self.friendship.iAmInitiator() {
            avatar = self.friendship.recieverAvatar
        } else if self.friendship.iAmReceiver() {
            avatar = self.friendship.initiatorAvatar
        }
        self.avatarView.displayAvatar(avatar: avatar)
        
        
        nameButton.setTitle(friend.name, for: .normal)
        if (friend.active == "1") {
            activeBubble.isHidden = false
        } else {
            activeBubble.isHidden = true
        }
        DataHandler.updateActive(active: "1")
        
        //If the friend is anonymous, use one of the default pictures.
        //We haven't implemented pictures yet so let's just leave it like this.
        //if friend.anon == "1" {
        if true {
            if friend.macStatus == "Daddy" {
                profilePicture.image = UIImage(named: "MacDaddyLogo_Purple")
            } else {
                profilePicture.image = UIImage(named: "MacDaddyLogo")
            }
        }
        
        convoStillExists {
            if self.convoExists {
                self.addTypingObserver()
                self.addDeletionObserver()
                
                if self.iSaved == true {
                    print("💖 Heart is pink because friend is saved")
                    self.heartButton.tintColor = Constants.colors.hotPink
                } else {
                    self.addSavedObserver()
                    print("💟 Heart is white because friend is not saved")
                    
                }
                
            } else {
                self.showUnfriendAlert()
            }
        }
        
        //Background
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            tabBarBackground.image = UIImage(named: "TabBar_Purple")?.alpha(1.0)
            
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
            tabBarBackground.image = UIImage(named: "TabBar")?.alpha(1.0)
        }
        tabBarBackground.image = UIImage(named: "MacDaddy Background_DarkMode")
        background.image = UIImage(named: "MacDaddy Background_DarkMode")
    }
    
    
    //MARK: Buttons
    
    @IBAction func friendButtonTapped(_ sender: Any) {
         self.performSegue(withIdentifier: "showFriendDetail", sender: nil)
    }
    
    
    //Use a custom segue here.
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromFriendChat", sender: nil)
    }
    
    @IBAction func heartPressed(_ sender: UIButton) {
        print("HEART BUTTON PRESSED")
        convoStillExists {
            if self.convoExists {
                if (self.friend.anon == "1" && self.iSaved == true) {
                    //If you're still waiting on your match, show an alert.
                    self.showWaitingAlert()
                } else if (self.friend.anon == "1" && self.iSaved == false) {
                    //If you're about to like a new match, show an alert.
                    self.showLikingAlert()
                } else if (self.friend.anon == "0") {
                    print("You're already friends.")
                } else {
                    print("Friend variables aren't initialized, these checks don't pass.")
                }
            } else {
                //If the conversation is gone, show that you have been unfriended.
                self.showUnfriendAlert()
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: SegueToLeft) {
        let source = segue.source as! FriendDetailVC
        self.friend = source.friend
        self.friendship = source.friendship
    }
    
}

