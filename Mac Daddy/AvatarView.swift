//
//  AvatarView.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/14/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class AvatarView: UIView {

    @IBOutlet var contentView: AvatarView!
    var avatarObject: AvatarObject?
    
    @IBOutlet weak var hair: UIImageView!
    @IBOutlet weak var nose: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    @IBOutlet weak var mouthShadow: UIImageView!
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var faceShadow: UIImageView!
    @IBOutlet weak var shirt: UIImageView!
    @IBOutlet weak var leftArmShadow: UIImageView!
    @IBOutlet weak var leftArm: UIImageView!
    @IBOutlet weak var rightArmShadow: UIImageView!
    @IBOutlet weak var rightArm: UIImageView!
    @IBOutlet weak var neck: UIImageView!
    @IBOutlet weak var hairBack: UIImageView!

    
    //For using custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.layer.isOpaque = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        commonInit()
    }
    
    //For using custom view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        //fatalError("init(coder:) has not been implemented")
    }
    
    //Initialize the view we designed in the view nib
    private func commonInit() {
        //Tip: make sure the content view is classed as a UIView, and the File's Owner is an AvatarView.
        Bundle.main.loadNibNamed("AvatarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.clear
        contentView.isOpaque = false
        
        self.avatarObject = AvatarObject.loadDefaultAvatar()
        displayAvatar()
        
    }
    
    func displayAvatar() {
        //let hairColor = UIColor(red: 0.99, green: 0.24, blue: 0.56, alpha: 1.00)
        //let faceColor = UIColor(red: 0.99, green: 0.50, blue: 0.70, alpha: 1.00)
        
        if avatarObject != nil {
            
            hair.image = UIImage(named: avatarObject?.hair ?? "hair1")
            nose.image = UIImage(named: avatarObject?.nose ?? "nose1")
            mouth.image = UIImage(named: avatarObject?.mouth ?? "mouth1")
            mouthShadow.image = UIImage(named: avatarObject?.mouthShadow ?? "mouthShadow1")
            face.image = UIImage(named: avatarObject?.face ?? "face1")
            faceShadow.image = UIImage(named: avatarObject?.faceShadow ?? "faceShadow")
            shirt.image = UIImage(named: avatarObject?.shirt ?? "shirt1")
            leftArmShadow.image = UIImage(named: avatarObject?.leftArmShadow ?? "leftArmShadow1")
            leftArm.image = UIImage(named: avatarObject?.leftArm ?? "leftArm1")
            rightArmShadow.image = UIImage(named: avatarObject?.rightArmShadow ?? "rightArmShadow1")
            rightArm.image = UIImage(named: avatarObject?.rightArm ?? "rightArm1")
            neck.image = UIImage(named: avatarObject?.neck ?? "neck1")
            nose.image = UIImage(named: avatarObject?.nose ?? "nose1")
            hairBack.image = UIImage(named: avatarObject?.hairBack ?? "nose1")
            
            print(avatarObject?.hairTone?.toRGB())
            hair.setImageColor(color: avatarObject?.hairTone?.toRGB() ?? .random())
            face.setImageColor(color: avatarObject?.skinTone?.toRGB() ?? .random())
            nose.setImageColor(color: avatarObject?.skinShadow?.toRGB() ?? .random())
            mouth.setImageColor(color: UIColor.white)
            
//            shirt.setImageColor(color: .random())
//            hair.setImageColor(color: .random())
//            face.setImageColor(color: .random())
//            nose.setImageColor(color: .random())
            hairBack.setImageColor(color: avatarObject?.hairTone?.toRGB() ?? .random())
            
        } else {
            print("Avatar object is nil")
        }
    }
    
}
