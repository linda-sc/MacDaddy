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
    
    var uid: String?
    var colorTone: String?
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
        case colorTone
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
    init(uid: String, email: String) {
        super.init()
        self.uid = uid
    }
    
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: IV. Initialization from decoder
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    
    //Initializing an object after decoding from JSON.
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        uid = try container.decodeIfPresent(String.self, forKey: .uid)
        colorTone = try container.decodeIfPresent(String.self, forKey: .colorTone)
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
        try container.encodeIfPresent(colorTone, forKey: .colorTone)
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
