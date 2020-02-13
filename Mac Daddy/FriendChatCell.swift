//
//  FriendChatCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import UIKit

class FriendChatCell: UITableViewCell {

//    @IBOutlet weak var friendPic:UIImageView!
    @IBOutlet weak var friendName:UILabel!
    @IBOutlet weak var friendChatPreview:UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var activeBubble: UIImageView!
    @IBOutlet weak var currentMatchLabel: UILabel!
    @IBOutlet weak var incomingMatchLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var elapsedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func update(with friendship: FriendshipObject) {
        
        
        let initiatorDidSee = friendship.initiatorSeen ?? true
        let recieverDidSee = friendship.recieverSeen ?? true
        
        //If you're the initiator, pull data for the reciever.
        if UserManager.shared.currentUser!.uid == friendship.initiatorId {
            self.avatarView.displayAvatar(avatar: friendship.recieverAvatar)
            self.activeBubble.isHidden = friendship.recieverActive ?? true
            if let time = friendship.recieverLastActive {
                self.elapsedLabel.text = "Active " + time.getElapsedInterval()
            } else {
                self.elapsedLabel.text = "Active during beta testing 2019"
            }
            
            if initiatorDidSee == false {
                self.friendChatPreview.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            } else {
                self.friendChatPreview.font = UIFont(name:"HelveticaNeue", size: 15.0)
            }
        } else {
             //If you're the reciever, pull data for the initiator.
            self.avatarView.displayAvatar(avatar: friendship.initiatorAvatar)
            self.activeBubble.isHidden = friendship.initiatorActive ?? true
            if let time = friendship.initiatorLastActive {
                self.elapsedLabel.text = "Active " + time.getElapsedInterval()
            } else {
                self.elapsedLabel.text = "Active during beta testing 2019"
            }
            
            if recieverDidSee == false {
                self.friendChatPreview.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            } else {
                self.friendChatPreview.font = UIFont(name:"HelveticaNeue", size: 16.0)
            }
        }

        self.friendChatPreview.text =
            friendship.mostRecentMessage
            ?? "is chatting with you."
    }
    
    //Change to friend object once you figure out how the matching works.
    func update(with friend:Friend) {
        
//        //Round corners of picture
//        friendPic.layer.cornerRadius = 10
//        friendPic.clipsToBounds = true
        
        //If the friend is anonymous, use one of the default pictures.
        //We haven't implemented pictures yet so let's just leave it like this.
        //if friend.anon == "1" {
//        if true {
//            if friend.macStatus == "Daddy" {
//                friendPic.image = UIImage(named: "MacDaddyLogo_Purple")
//            } else {
//                friendPic.image = UIImage(named: "MacDaddyLogo")
//            }
//        }
        
        //Highlight your current match
        if (friend.uid == DataHandler.currentMatchID) {
            currentMatchLabel.isHidden = false
            incomingMatchLabel.isHidden = true
            
        //Show incoming matches
        } else if (friend.anon == "1"){
            currentMatchLabel.isHidden = true
            incomingMatchLabel.isHidden = false
        } else {
        //Else if the match is a friend then hide labels
            currentMatchLabel.isHidden = true
            incomingMatchLabel.isHidden = true
        }
        
        
        //Show active indicator
        if friend.active == "0" {
            activeBubble.isHidden = true
        } else if friend.active == "1" {
            activeBubble.isHidden = false
        } else {
            activeBubble.isHidden = true
        }
        
        
        //Set Labels
        friendName.text = friend.name
        
        //So you see if you liked them already or not.
        if (friend.anon == "0") {
            self.heart.isHidden = false
            //let heartColor = UIColor(Constants.colors.shadow)
            //self.heart.setImageColor(color: heartColor)
        } else {
          self.heart.isHidden = true
        }

        
    }

}
