//
//  FriendChatCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import UIKit

class FriendChatCell: UITableViewCell {

    @IBOutlet weak var friendPic:UIImageView!
    @IBOutlet weak var friendName:UILabel!
    @IBOutlet weak var friendChatPreview:UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var activeBubble: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Change to friend object once you figure out how the matching works.
    func update(with friend:Friend) {
        
        //Round corners of picture
        friendPic.layer.cornerRadius = 10
        friendPic.clipsToBounds = true
        
        //If the friend is anonymous, use one of the default pictures.
        //We haven't implemented pictures yet so let's just leave it like this.
        //if friend.anon == "y" {
        if true {
            if friend.macStatus == "Daddy" {
                friendPic.image = UIImage(named: "MacDaddyLogo_Purple")
            } else {
                friendPic.image = UIImage(named: "MacDaddyLogo")
            }
        }
        
        //Show active indicator
        if friend.active == "n" {
            activeBubble.isHidden = true
        } else {
            activeBubble.isHidden = false
        }
        
        
        //Set Labels
        friendName.text = friend.name
        //friendChatPreview.text = show previous message
        friendChatPreview.text = "is now chatting with you!"
        
        //So you see if you liked them already or not.
        if (friend.anon == "n") {
            self.heart.isHidden = false
        } else {
          self.heart.isHidden = true
        }

        
    }

}
