//
//  GigObject.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/17/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// MARK: Five steps in making a codable object:
// I. Define the variables
// II. Set the coding keys - the keys in the JSON key value pairs
// III. Normal Init
// IV. Init from decoder - how do we translate JSON keys into object variables?
// V. Encoding back to JSON
//////////////////////////////////////////////////
//////////////////////////////////////////////////


class SponsorObject: NSObject, Codable {

    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: I. Variables
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////

    //1. Basic Information
    var uid: String?
    var email: String?
    var organization: String?
    var text: String?
    var timeStamp: Date?
    
    var imageName: String?
    var imageUrl: String?

    var avatar: AvatarObject?

    //2. Custom Information
    var firstName: String?
    var lastName: String?
    var fullName: String?
    var venmo: String?

    var score: Int?
    var responses: Int?
    var completed: Bool?

    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: II. Coding Keys
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //These tell Codable which keys to use from the JSON.

    enum UserCodingKeys: String, CodingKey {

        //1. Basic Information
        case uid
        case email
        case organization
        case text
        case timeStamp
        
        case imageName
        case imageUrl

        case firstName
        case lastName
        case fullName
        case venmo

        case avatar

        case score
        case responses
        case completed
    }

    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: III. Normal Initialization
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    init(uid: String, imageName: String) {
        super.init()
        self.uid = uid
        self.imageName = imageName
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
        
        //1. Basic Information
        uid = try container.decodeIfPresent(String.self, forKey: .uid)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        organization  = try container.decodeIfPresent(String.self, forKey: .organization)
        text  = try container.decodeIfPresent(String.self, forKey: .text)
        
        imageName  = try container.decodeIfPresent(String.self, forKey: .imageName)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        
        //Convert the date string into a date object.
         let timeStampString = try container.decodeIfPresent(String.self, forKey: .timeStamp)
         let dateTimeFormatter = DateFormatter.iso8601Full
         if let date = dateTimeFormatter.date(from: timeStampString ?? "") {
             timeStamp = date
         } else {
             if timeStampString != nil {
                 throw DecodingError.dataCorruptedError(forKey: .timeStamp,
                                                        in: container,
                                                        debugDescription: "Time stamp date string does not match format expected by formatter.")
             }
         }

        //3. Custom Information
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        venmo = try container.decodeIfPresent(String.self, forKey: .venmo)
        
        //5. Stats information
        score = try container.decodeIfPresent(Int.self, forKey: .score)
        responses = try container.decodeIfPresent(Int.self, forKey: .responses)
        completed = try container.decodeIfPresent(Bool.self, forKey: .completed)

    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: V. Encoding back to JSON.
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //This is the easy part.

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
        
        //1. Basic Information
        try container.encodeIfPresent(uid, forKey: .uid)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(organization, forKey: .organization)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(imageName, forKey: .imageName)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        
        //Convert the date into a string to make it JSON encodable
        let timeStampString = timeStamp?.dateToDateTimeString()
        try container.encodeIfPresent(timeStampString, forKey: .timeStamp)

        //3. Custom Information
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(venmo, forKey: .venmo)
    
        //5. Stats information
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(responses, forKey: .responses)
        try container.encodeIfPresent(completed, forKey: .completed)

    }
    
    func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? GigObject {
            return self.uid == object.uid
        }
        return false
    }
    
}


