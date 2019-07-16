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
            
            //avatarObject?.baseColor = UIColor.random().toHex()
            //RANDOM TIME
            
            avatarObject?.hairLuminosity = Int.randomIntInRange(lower: -50, upper: 50)
            avatarObject?.skinLuminosity = Int.randomIntInRange(lower: -30, upper: 30)
            
            let randomHair = Int.randomIntInRange(lower: 1, upper: 4)
            switch randomHair {
            case 1:
                hair.image = UIImage(named: avatarObject?.hair ?? "hair1")
                hairBack.image = UIImage(named: avatarObject?.hairBack ?? "hairBack1")
            case 2:
                hair.image = UIImage(named: "hair2")
                hairBack.image = nil
            case 3:
                hair.image = UIImage(named: "hair3")
                hairBack.image = nil
            default:
                hair.image = UIImage(named: "hair4")
                hairBack.image = nil
            }
            
            let randomFace = Int.randomIntInRange(lower: 1, upper: 3)
            switch randomFace {
            case 1:
                face.image = UIImage(named: avatarObject?.face ?? "face1")
                faceShadow.image = UIImage(named: avatarObject?.faceShadow ?? "faceShadow1")
            case 2:
                face.image = UIImage(named: "face2")
                faceShadow.image = UIImage(named: "faceShadow2")
            default:
                face.image = UIImage(named: "face3")
                faceShadow.image = UIImage(named: "faceShadow3")
            }
            
            //Note: left and right correspond to the body of the avatar, not the viewer.
            let randomBody = Int.randomIntInRange(lower: 1, upper: 2)
            switch randomBody {
            case 1:
                shirt.image = UIImage(named: avatarObject?.shirt ?? "shirt1")
                leftArm.image = UIImage(named: avatarObject?.leftArm ?? "leftArm1")
                leftArmShadow.image = UIImage(named: avatarObject?.leftArmShadow ?? "leftArmShadow1")
                rightArm.image = UIImage(named: avatarObject?.rightArm ?? "rightArm1")
                rightArmShadow.image = UIImage(named: avatarObject?.rightArmShadow ?? "rightArmShadow1")
            default:
                shirt.image = UIImage(named: "shirt3")
                leftArm.image = UIImage(named: "leftArm3")
                leftArmShadow.image = UIImage(named: "leftArmShadow3")
                rightArm.image = UIImage(named: "rightArm3")
                rightArmShadow.image = UIImage(named: "rightArmShadow3")
            }
      
            
            let randomMouth = Int.randomIntInRange(lower: 1, upper: 3)
            switch randomMouth {
            case 1:
                mouth.image = UIImage(named: "mouth1")
                mouthShadow.image = UIImage(named: "mouthShadow1")
            case 2:
                mouth.image = UIImage(named: "mouth2")
                mouthShadow.image = UIImage(named: "mouthShadow2")
            default:
                mouth.image = UIImage(named: "mouth3")
                mouthShadow.image = UIImage(named: "mouthShadow3")
            }
            
            //hair.image = UIImage(named: avatarObject?.hair ?? "hair1")
            //hairBack.image = UIImage(named: avatarObject?.hairBack ?? "hairBack1")
            
            nose.image = UIImage(named: avatarObject?.nose ?? "nose1")
            //mouth.image = UIImage(named: avatarObject?.mouth ?? "mouth1")
            //mouthShadow.image = UIImage(named: avatarObject?.mouthShadow ?? "mouthShadow1")
            
//            face.image = UIImage(named: avatarObject?.face ?? "face1")
//            faceShadow.image = UIImage(named: avatarObject?.faceShadow ?? "faceShadow")
            
            //shirt.image = UIImage(named: avatarObject?.shirt ?? "shirt1")
            //leftArmShadow.image = UIImage(named: avatarObject?.leftArmShadow ?? "leftArmShadow1")
            //leftArm.image = UIImage(named: avatarObject?.leftArm ?? "leftArm1")
            //rightArmShadow.image = UIImage(named: avatarObject?.rightArmShadow ?? "rightArmShadow1")
            //rightArm.image = UIImage(named: avatarObject?.rightArm ?? "rightArm1")
            
            neck.image = UIImage(named: avatarObject?.neck ?? "neck1")
            
            if let hairColor = avatarObject?.baseColor?.toRGB()?.adjust(by: CGFloat(avatarObject?.hairLuminosity ?? 0)) {
                avatarObject?.hairTone = hairColor.toHex()
                avatarObject?.eyebrowTone = hairColor.darker(by: 10)?.toHex()
                hair.setImageColor(color: hairColor)
                hairBack.setImageColor(color: hairColor.darker(by: 5) ?? hairColor)
            }
  
            if let skinColor = avatarObject?.baseColor?.toRGB()?.adjust(by: CGFloat(avatarObject?.skinLuminosity ?? 0)) {
                avatarObject?.skinTone = skinColor.toHex()
                avatarObject?.skinShadow = skinColor.darker(by: 10)?.toHex()
                
                face.setImageColor(color: skinColor)
                neck.setImageColor(color: skinColor)
                leftArm.setImageColor(color: skinColor)
                rightArm.setImageColor(color: skinColor)
                nose.setImageColor(color: skinColor.darker(by: 10) ?? skinColor)
                mouthShadow.setImageColor(color: skinColor.darker(by: 10) ?? skinColor)
                faceShadow.setImageColor(color: skinColor.darker(by: 10) ?? skinColor)
                leftArmShadow.setImageColor(color: skinColor.darker(by: 10) ?? skinColor)
                rightArmShadow.setImageColor(color: skinColor.darker(by: 10) ?? skinColor)
            }
            mouth.setImageColor(color: UIColor.white)
            
            
        } else {
            print("Avatar object is nil")
        }
    }
    
}
