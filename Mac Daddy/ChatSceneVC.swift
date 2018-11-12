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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tabBarBackground: UIImageView!
    
    
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        nameLabel.text = friend.name
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
            tabBarBackground.image = UIImage(named: "MacDaddy Background_Purple")
            
        }else if DataHandler.macStatus == "Baby" {
            background.image = UIImage(named: "MacDaddy Background")
            tabBarBackground.image = UIImage(named: "MacDaddy Background")
        }
    }
    
    
}
