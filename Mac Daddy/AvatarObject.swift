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
    var eyebrownTone: String?
    
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
    
}
