//
//  AvatarObject.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/14/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation

class AvatarObject: NSObject, Codable {
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: I. Variables
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    
    
    //Categorical: Base color, features styles, clothing
    //Continuous: Skin lumosity, Hair lumosity
    
    
    var uid: String?
    
    var baseColor: String?
    var hairLuminosity: Int?
    var skinLuminosity: Int?
    var browLuminosity: Int?
    
    var hairTone: String?
    var skinTone: String?
    var skinShadow: String?
    var eyeTone: String?
    var eyebrowTone: String?
    
    var hair: String?
    var hairShadow: String?
    var hairBack: String?
    
    var eyes: String?
    var irises: String?
    var eyeBags: String?
    var eyeSize: Double?
    var eyeHeight: Double?
    var eyeWidth: Double?
    
    var nose: String?
    var noseSize: Double?
    
    var mouth: String?
    var mouthShadow: String?
    var mouthSize: Double?
    
    var face: String?
    var faceShadow: String?
    var neck: String?
    
    var shirt: String?
    var leftArm: String?
    var leftArmShadow: String?
    var rightArm: String?
    var rightArmShadow: String?
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: II. Coding Keys
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //These tell Codable which keys to use from the JSON.
    
    enum UserCodingKeys: String, CodingKey {
        
        case uid
        
        case baseColor
        case hairLuminosity
        case skinLuminosity
        case browLuminosity
        
        case hairTone
        case skinTone
        case skinShadow
        case eyeTone
        case eyebrowTone
        
        case hair
        case hairShadow
        case hairBack
        
        case eyes
        case irises
        case eyeBags
        case eyeSize
        case eyeHeight
        case eyeWidth
        
        case nose
        case noseSize
        
        case mouth
        case mouthShadow
        case mouthSize
        
        case face
        case faceShadow
        case neck
        
        case shirt
        case leftArm
        case leftArmShadow
        case rightArm
        case rightArmShadow
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: III. Normal Initialization
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    init(uid: String) {
        super.init()
        self.uid = uid
    }
    
     override init() {}
    
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: IV. Initialization from decoder
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    
    //Initializing an object after decoding from JSON.
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        uid = try container.decodeIfPresent(String.self, forKey: .uid)
        
        baseColor = try container.decodeIfPresent(String.self, forKey: .baseColor)
        hairLuminosity = try container.decodeIfPresent(Int.self, forKey: .hairLuminosity)
        skinLuminosity = try container.decodeIfPresent(Int.self, forKey: .skinLuminosity)
        browLuminosity = try container.decodeIfPresent(Int.self, forKey: .browLuminosity)
        
        hairTone = try container.decodeIfPresent(String.self, forKey: .hairTone)
        skinTone = try container.decodeIfPresent(String.self, forKey: .skinTone)
        skinShadow = try container.decodeIfPresent(String.self, forKey: .skinShadow)
        eyeTone = try container.decodeIfPresent(String.self, forKey: .eyeTone)
        eyebrowTone = try container.decodeIfPresent(String.self, forKey: .eyebrowTone)

        hair = try container.decodeIfPresent(String.self, forKey: .hair)
        hairShadow = try container.decodeIfPresent(String.self, forKey: .hairShadow)
        hairBack = try container.decodeIfPresent(String.self, forKey: .hairBack)
        
        eyes = try container.decodeIfPresent(String.self, forKey: .eyes)
        irises = try container.decodeIfPresent(String.self, forKey: .irises)
        eyeBags = try container.decodeIfPresent(String.self, forKey: .eyeBags)
        eyeSize = try container.decodeIfPresent(Double.self, forKey: .eyeSize)
        eyeHeight = try container.decodeIfPresent(Double.self, forKey: .eyeHeight)
        eyeWidth = try container.decodeIfPresent(Double.self, forKey: .eyeWidth)

        nose = try container.decodeIfPresent(String.self, forKey: .nose)
        noseSize = try container.decodeIfPresent(Double.self, forKey: .noseSize)

        mouth = try container.decodeIfPresent(String.self, forKey: .mouth)
        mouthShadow = try container.decodeIfPresent(String.self, forKey: .mouthShadow)
        mouthSize = try container.decodeIfPresent(Double.self, forKey: .mouthSize)

        face = try container.decodeIfPresent(String.self, forKey: .face)
        faceShadow = try container.decodeIfPresent(String.self, forKey: .faceShadow)
        neck = try container.decodeIfPresent(String.self, forKey: .neck)

        shirt = try container.decodeIfPresent(String.self, forKey: .shirt)
        leftArm = try container.decodeIfPresent(String.self, forKey: .leftArm)
        leftArmShadow = try container.decodeIfPresent(String.self, forKey: .leftArmShadow)
        rightArm = try container.decodeIfPresent(String.self, forKey: .rightArm)
        rightArmShadow = try container.decodeIfPresent(String.self, forKey: .rightArmShadow)

    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: V. Encoding back to JSON.
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //This is the easy part.
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
        
        try container.encodeIfPresent(uid, forKey: .uid)
        
        try container.encodeIfPresent(baseColor, forKey: .baseColor)
        try container.encodeIfPresent(hairLuminosity, forKey: .hairLuminosity)
        try container.encodeIfPresent(skinLuminosity, forKey: .skinLuminosity)
        try container.encodeIfPresent(browLuminosity, forKey: .browLuminosity)
        
        
        try container.encodeIfPresent(hairTone, forKey: .hairTone)
        try container.encodeIfPresent(skinTone, forKey: .skinTone)
        try container.encodeIfPresent(skinShadow, forKey: .skinShadow)
        try container.encodeIfPresent(eyeTone, forKey: .eyeTone)
        try container.encodeIfPresent(eyebrowTone, forKey: .eyebrowTone)
        
        try container.encodeIfPresent(hair, forKey: .hair)
        try container.encodeIfPresent(hairShadow, forKey: .hairShadow)
        try container.encodeIfPresent(hairBack, forKey: .hairBack)
        
        try container.encodeIfPresent(eyes, forKey: .eyes)
        try container.encodeIfPresent(irises, forKey: .irises)
        try container.encodeIfPresent(eyeBags, forKey: .eyeBags)
        try container.encodeIfPresent(eyeSize, forKey: .eyeSize)
        try container.encodeIfPresent(eyeHeight, forKey: .eyeHeight)
        try container.encodeIfPresent(eyeWidth, forKey: .eyeWidth)
        
        try container.encodeIfPresent(nose, forKey: .nose)
        try container.encodeIfPresent(noseSize, forKey: .noseSize)
        
        try container.encodeIfPresent(mouth, forKey: .mouth)
        try container.encodeIfPresent(mouthShadow, forKey: .mouthShadow)
        try container.encodeIfPresent(mouthSize, forKey: .mouthSize)
        
        try container.encodeIfPresent(face, forKey: .face)
        try container.encodeIfPresent(faceShadow, forKey: .faceShadow)
        try container.encodeIfPresent(neck, forKey: .neck)
        
        try container.encodeIfPresent(shirt, forKey: .shirt)
        try container.encodeIfPresent(leftArm, forKey: .leftArm)
        try container.encodeIfPresent(leftArmShadow, forKey: .leftArmShadow)
        try container.encodeIfPresent(rightArm, forKey: .rightArm)
        try container.encodeIfPresent(rightArmShadow, forKey: .rightArmShadow)
    }
    
}


//////////////////////////////////////////////////
//////////////////////////////////////////////////
// MARK: Functions
//////////////////////////////////////////////////
//////////////////////////////////////////////////

public enum ColorStyle {
    case sugar
    case magic
    case dream
    case royal
    case icy
    case glow
    case shadow
    
    var baseColor: String {
        switch self {
        case .sugar: return "f54284"
        case .magic: return "e26ee6"
        case .dream: return "7f64fa"
        case .royal: return "595cff"
        case .icy: return "36d3ff"
        case .glow: return "##86c5ff"
        case .shadow: return "#b1afea"
        }
    }
}

extension AvatarObject {
    
    
    //MARK: Load default avatar
    static func loadDefaultAvatar() -> AvatarObject {
        
        let newAvatar = AvatarObject()
        
        var uid: String?
    
        //newAvatar.baseColor = "002fff"
        let random = Int.randomIntInRange(lower: 0, upper: 4)
        switch random {
        case 0:
            newAvatar.baseColor = ColorStyle.sugar.baseColor
        case 1:
            newAvatar.baseColor = ColorStyle.magic.baseColor
        case 2:
            newAvatar.baseColor = ColorStyle.dream.baseColor
        case 3:
            newAvatar.baseColor = ColorStyle.royal.baseColor
        case 4:
            newAvatar.baseColor = ColorStyle.icy.baseColor
        default:
            print("Error picking base color")
        }
    
        newAvatar.hairLuminosity = -20
        newAvatar.skinLuminosity = 20
        newAvatar.browLuminosity = -20
        
        newAvatar.hairTone = ""
        newAvatar.skinTone = ""
        newAvatar.skinShadow = ""
        newAvatar.eyeTone = ""
        newAvatar.eyebrowTone = ""
        
        newAvatar.hair = "hair1"
        newAvatar.hairShadow = "hairShadow1"
        newAvatar.hairBack = "hairBack1"
        
        newAvatar.eyes = ""
        newAvatar.irises = ""
        newAvatar.eyeBags = ""
        newAvatar.eyeSize = 1.0
        newAvatar.eyeHeight = 1.0
        newAvatar.eyeWidth = 1.0
        
        newAvatar.nose = "nose1"
        newAvatar.noseSize = 1.0
        
        newAvatar.mouth = "mouth1"
        newAvatar.mouthShadow = "mouthShadow1"
        newAvatar.mouthSize = 1.0
        
        newAvatar.face = "face1"
        newAvatar.faceShadow = "faceShadow1"
        newAvatar.neck = "neck1"
        
        newAvatar.shirt = "shirt1"
        newAvatar.leftArm = "leftArm1"
        newAvatar.leftArmShadow = "leftArmShadow1"
        newAvatar.rightArm = "rightArm1"
        newAvatar.rightArmShadow = "rightArmShadow1"
        
        return newAvatar
    }
    
    //MARK: Create random avatar

    static func createRandomAvatar() -> AvatarObject {
        
        let newAvatar = AvatarObject()

        //Generate random color
        let random = Int.randomIntInRange(lower: 0, upper: 5)
        switch random {
        case 0:
            newAvatar.baseColor = ColorStyle.sugar.baseColor
        case 1:
            newAvatar.baseColor = ColorStyle.magic.baseColor
        case 2:
            newAvatar.baseColor = ColorStyle.dream.baseColor
        case 3:
            newAvatar.baseColor = ColorStyle.royal.baseColor
        case 4:
            newAvatar.baseColor = ColorStyle.icy.baseColor
        case 5:
            newAvatar.baseColor = ColorStyle.glow.baseColor
        default:
            print("Error picking base color")
        }
        
        //Pick random lumosity
        newAvatar.hairLuminosity = Int.randomIntInRange(lower: -50, upper: 50)
        newAvatar.skinLuminosity = Int.randomIntInRange(lower: -30, upper: 30)
        
        //Random hairstyle
        let randomHair = Int.randomIntInRange(lower: 1, upper: 6)
        switch randomHair {
        case 1:
            newAvatar.hair = "hair1"
            newAvatar.hairBack = "hairBack1"
        case 2:
            newAvatar.hair = "hair2"
            newAvatar.hairBack = "blankAvatarAsset"
        case 3:
            newAvatar.hair = "hair3"
            newAvatar.hairBack = "blankAvatarAsset"
        case 4:
            newAvatar.hair = "hair4"
            newAvatar.hairBack = "blankAvatarAsset"
        case 5:
            newAvatar.hair = "hairGrace"
            newAvatar.hairBack = "hairBack2"
        default:
            newAvatar.hair = "hairLia"
            newAvatar.hairBack = "blankAvatarAsset"
        }
        
        //Random face
        newAvatar.neck = "neck1"
        let randomFace = Int.randomIntInRange(lower: 1, upper: 3)
        switch randomFace {
        case 1:
            newAvatar.face = "face1"
            newAvatar.faceShadow = "faceShadow1"
        case 2:
            newAvatar.face = "face2"
            newAvatar.faceShadow = "faceShadow2"
        default:
            newAvatar.face = "face3"
            newAvatar.faceShadow = "faceShadow3"
        }

        newAvatar.hairTone = ""
        newAvatar.skinTone = ""
        newAvatar.skinShadow = ""
        newAvatar.eyeTone = ""
        newAvatar.eyebrowTone = ""
        
        newAvatar.eyes = "blankAvatarAsset"
        newAvatar.irises = "blankAvatarAsset"
        newAvatar.eyeBags = "blankAvatarAsset"
        newAvatar.eyeSize = 1.0
        newAvatar.eyeHeight = 1.0
        newAvatar.eyeWidth = 1.0
        
        //Random nose
        newAvatar.noseSize = 1.0
        let randomNose = Int.randomIntInRange(lower: 1, upper: 3)
        switch randomNose {
        case 1:
            newAvatar.nose = "nose1"
        case 2:
            newAvatar.nose = "nose2"
        default:
            newAvatar.nose = "nose3"
        }
        
        //Random mouth
        newAvatar.mouthSize = 1.0
        let randomMouth = Int.randomIntInRange(lower: 1, upper: 5)
        switch randomMouth {
        case 1:
            newAvatar.mouth = "mouth1"
            newAvatar.mouthShadow = "mouthShadow1"
        case 2:
            newAvatar.mouth = "mouth2"
            newAvatar.mouthShadow = "mouthShadow2"
        case 3:
            newAvatar.mouth = "mouth3"
            newAvatar.mouthShadow = "mouthShadow3"
        case 4:
            newAvatar.mouth = "mouth4"
            newAvatar.mouthShadow = "mouthShadow4"
        default:
            newAvatar.mouth = "blankAvatarAsset"
            newAvatar.mouthShadow = "mouthShadowPout"
        }

        //Note: left and right correspond to the body of the avatar, not the viewer.
        let randomBody = Int.randomIntInRange(lower: 1, upper: 2)
        switch randomBody {
        case 1:
            newAvatar.shirt = "shirt1"
            newAvatar.leftArm = "leftArm1"
            newAvatar.leftArmShadow = "leftArmShadow1"
            newAvatar.rightArm = "rightArm1"
            newAvatar.rightArmShadow = "rightArmShadow1"
        default:
            newAvatar.shirt = "shirt3"
            newAvatar.leftArm = "leftArm3"
            newAvatar.leftArmShadow = "leftArmShadow3"
            newAvatar.rightArm = "rightArm3"
            newAvatar.rightArmShadow = "rightArmShadow3"
        }
        
        return newAvatar
    }
    
    
    func changeBaseColor(){
        //Generate random color
        let random = Int.randomIntInRange(lower: 0, upper: 5)
        switch random {
        case 0:
            self.baseColor = ColorStyle.sugar.baseColor
        case 1:
            self.baseColor = ColorStyle.magic.baseColor
        case 2:
            self.baseColor = ColorStyle.dream.baseColor
        case 3:
            self.baseColor = ColorStyle.royal.baseColor
        case 4:
            self.baseColor = ColorStyle.icy.baseColor
        case 5:
            self.baseColor = ColorStyle.glow.baseColor
        default:
            print("Error picking base color")
        }
    }
    
    func changeShirt(){
        //Note: left and right correspond to the body of the avatar, not the viewer.
           let randomBody = Int.randomIntInRange(lower: 1, upper: 2)
           switch randomBody {
           case 1:
               self.shirt = "shirt1"
               self.leftArm = "leftArm1"
               self.leftArmShadow = "leftArmShadow1"
               self.rightArm = "rightArm1"
               self.rightArmShadow = "rightArmShadow1"
           default:
               self.shirt = "shirt3"
               self.leftArm = "leftArm3"
               self.leftArmShadow = "leftArmShadow3"
               self.rightArm = "rightArm3"
               self.rightArmShadow = "rightArmShadow3"
           }
        
    }
    
    
}


