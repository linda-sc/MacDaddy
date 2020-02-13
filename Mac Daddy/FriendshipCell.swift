//
//  FriendshipCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/12/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class FriendshipCell: UICollectionViewCell {
    
    //NO MORE FUCKING AROUND

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var incomingMatchLabel: UILabel!
    @IBOutlet weak var currentMatchLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var redBubble: UIImageView!
    @IBOutlet weak var messagePreview: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var activeBubble: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //This is important.
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView)}
    }
    
    //MARK: Update with friend object
    func update(with friendship: FriendshipObject) {
        
        //MARK: 1. Seen and unseen variables

        let initiatorDidSee = friendship.initiatorSeen ?? true
        let recieverDidSee = friendship.recieverSeen ?? true
        
        //MARK: 2. Side-specifics...

        //MARK: if you're the initiator
        if friendship.iAmInitiator() {
        
            self.avatarView.displayAvatar(avatar: friendship.recieverAvatar)
   
            self.activeBubble.isHidden = friendship.recieverActive ?? true
            if let time = friendship.recieverLastActive {
                self.elapsedLabel.text = "Active " + time.getElapsedInterval()
            } else {
                self.elapsedLabel.text = "Active during beta testing 2019"
            }
            
            if initiatorDidSee == false {
                self.redBubble.isHidden = false
                self.messagePreview.textColor = UIColor.white
            } else {
                self.redBubble.isHidden = true
                self.messagePreview.textColor = Constants.colors.shadow

            }
            
            if friendship.recieverActive ?? false {
                self.activeBubble.isHidden = false
            } else {
                self.activeBubble.isHidden = true
            }
            
        } else if friendship.iAmReceiver() {
            //MARK: if you're the reciever
            self.avatarView.displayAvatar(avatar: friendship.initiatorAvatar)

            
            self.activeBubble.isHidden = friendship.initiatorActive ?? true
            if let time = friendship.initiatorLastActive {
                self.elapsedLabel.text = "Active " + time.getElapsedInterval()
            } else {
                self.elapsedLabel.text = "Active during beta testing 2019"
            }
            
            if recieverDidSee == false {
                self.redBubble.isHidden = false
                self.messagePreview.textColor = UIColor.white
            } else {
                self.redBubble.isHidden = true
                self.messagePreview.textColor = Constants.colors.shadow

            }
            
            if friendship.initiatorActive ?? false {
                self.activeBubble.isHidden = false
            } else {
                self.activeBubble.isHidden = true
            }
        }
    

        //MARK: 3. Message preview

        self.messagePreview.text =
            friendship.mostRecentMessage
            ?? "is chatting with you."
        
           //MARK: 4. Chat last active
        self.timeLabel.text = friendship.lastActive?.getElapsedInterval()
    }
    
    
    //MARK: Update with friend struct
        func update(with friend:Friend) {
            nameLabel.text = friend.name
            
            //Highlight your current match
            if (friend.uid == DataHandler.currentMatchID) {
                currentMatchLabel.isHidden = false
                incomingMatchLabel.isHidden = true
                
            //Show incoming matches
            } else if (friend.anon == "1"){
                emailLabel.isHidden = true
                currentMatchLabel.isHidden = true
                incomingMatchLabel.isHidden = false
            } else {
            //Else if the match is a friend then hide labels
                currentMatchLabel.isHidden = true
                incomingMatchLabel.isHidden = true
                //Change later
                emailLabel.isHidden = true
            }
        
            //So you see if you liked them already or not.
            if (friend.anon == "0") {
                self.heartButton.isHidden = false
            } else {
              self.heartButton.isHidden = true
            }

            
        }

}
