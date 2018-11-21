//
//  ChatSceneVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/3/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit
import Foundation

class ChatSceneVC: UIViewController {
   
    
    @IBOutlet weak var background:UIImageView!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var tabBarBackground: UIImageView!
    @IBOutlet weak var profileBar: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var activeBubble: UIImageView!
    
    
    
    var friend = Friend()
    var friendsRealName = ""
    
    var convoExists = true
    var iSaved = false
    var theySaved = false
    var anon = true
    var friendTyping = false
    
    //Embed the ChatInterfaceVC inside the scene:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedChatSegue" {
            if let childVC = segue.destination as? ChatInterfaceVC {
                //Some property on ChildVC that needs to be set
                childVC.friend = self.friend
            }
        } else if segue.identifier == "showFriendDetail" {
                let destination = segue.destination as! FriendDetailVC
                destination.friend = self.friend
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
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        nameButton.setTitle(friend.name, for: .normal)
        if (friend.active == "1") {
            activeBubble.isHidden = false
        } else {
            activeBubble.isHidden = true
        }
        DataHandler.updateActive(active: "1")
        
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
            tabBarBackground.image = UIImage(named: "TabBar_Purple")?.alpha(0.5)
            
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
            tabBarBackground.image = UIImage(named: "TabBar")?.alpha(0.5)
        }
    }
    
    
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
                } else {
                    print("Friend variables aren't initailized, these checks don't pass.")
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
    }
    
}

