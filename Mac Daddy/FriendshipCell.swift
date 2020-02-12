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
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var incomingMatchLabel: UILabel!
    @IBOutlet weak var currentMatchLabel: UILabel!
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var redBubble: UIImageView!
    @IBOutlet weak var messagePreview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //This is important.
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView)}
    }

}
