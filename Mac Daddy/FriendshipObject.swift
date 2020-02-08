//
//  FriendshipObject.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/17/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class FriendshipObject: NSObject, Codable {
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: I. Variables
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////

    var convoId: String?
    var initiatorId: String?
    var recieverId: String?
    var archived: Bool?
    
    var initiator: UserObject?
    var reciever: UserObject?

    var initiatorMostRecentMessage: String?
    var recieverMostRecentMessage: String?
    
    var initiatorLastActive: Date?
    var recieverLastActive: Date?
    
    var initiatorLiked: Bool?
    var recieverLiked: Bool?
    
    var initiatorSeen: Bool?
    var recieverSeen: Bool?
    
    var initiatorNumberUnread: Int?
    var recieverNumberUnread: Int?

    var messages: [String]?
    var totalMessages: Int?
    var totalCharacters: Int?
    var totalExchanges: Int?
    var commonInterests: [String]?
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: II. Coding Keys
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //These tell Codable which keys to use from the JSON.
    
    enum UserCodingKeys: String, CodingKey {
        case convoId
        case initiatorId
        case recieverId
        case archived
        
        case initiator
        case reciever
        
        case initiatorMostRecentMessage
        case recieverMostRecentMessage
        
        case initiatorLastActive
        case recieverLastActive
        
        case initiatorLiked
        case recieverLiked
        
        case initiatorSeen
        case recieverSeen
        
        case initiatorNumberUnread
        case recieverNumberUnread
        
        case messages
        case totalMessages
        case totalCharacters
        case totalExchanges
        case commonInterests
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: III. Normal Initialization
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    init(id: String, initiatorId: String, recieverId: String) {
        super.init()
        self.convoId = id
        self.initiatorId = initiatorId
        self.recieverId = recieverId
        self.archived = false
    }

    override init() {}
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: IV. Initialization from decoder
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        convoId = try container.decodeIfPresent(String.self, forKey: .convoId)
        initiatorId = try container.decodeIfPresent(String.self, forKey: .initiatorId)
        recieverId = try container.decodeIfPresent(String.self, forKey: .recieverId)
        archived = try container.decodeIfPresent(Bool.self, forKey: .archived)

        
        initiatorMostRecentMessage = try container.decodeIfPresent(String.self, forKey: .initiatorMostRecentMessage)
        
        //Convert the date strings into a date objects
        let initiatorLastActiveString = try container.decodeIfPresent(String.self, forKey: .initiatorLastActive)
        let dateTimeFormatter = DateFormatter.iso8601Full
        if let initiatorLastActiveDate = dateTimeFormatter.date(from: initiatorLastActiveString ?? "") {
            initiatorLastActive = initiatorLastActiveDate
        } else {
            if initiatorLastActiveString != nil {
                throw DecodingError.dataCorruptedError(forKey: .initiatorLastActive,
                                                       in: container,
                                                       debugDescription: "InitiatorLastActive date string does not match format expected by formatter.")
            }
        }

        //Convert the date strings into a date objects
         let recieverLastActiveString = try container.decodeIfPresent(String.self, forKey: .recieverLastActive)
         if let recieverLastActiveDate = dateTimeFormatter.date(from: initiatorLastActiveString ?? "") {
             recieverLastActive = recieverLastActiveDate
         } else {
             if initiatorLastActiveString != nil {
                 throw DecodingError.dataCorruptedError(forKey: .recieverLastActive,
                                                        in: container,
                                                        debugDescription: "RecieverLastActive date string does not match format expected by formatter.")
             }
         }
        
        initiatorLiked = try container.decodeIfPresent(Bool.self, forKey: .initiatorLiked)
        recieverLiked = try container.decodeIfPresent(Bool.self, forKey: .recieverLiked)

        initiatorSeen = try container.decodeIfPresent(Bool.self, forKey: .initiatorSeen)
        recieverSeen = try container.decodeIfPresent(Bool.self, forKey: .initiatorSeen)
 
        initiatorNumberUnread = try container.decodeIfPresent(Int.self, forKey: .initiatorNumberUnread)
        recieverNumberUnread = try container.decodeIfPresent(Int.self, forKey: .recieverNumberUnread)
        

        totalMessages = try container.decodeIfPresent(Int.self, forKey: .totalMessages)
        totalCharacters = try container.decodeIfPresent(Int.self, forKey: .totalCharacters)
        totalExchanges = try container.decodeIfPresent(Int.self, forKey: .totalExchanges)
        
        commonInterests = try container.decodeIfPresent([String].self, forKey: .totalExchanges)
    }
    
    //////////////////////////////////////////////////
      //////////////////////////////////////////////////
      // MARK: V. Encoding back to JSON.
      //////////////////////////////////////////////////
      //////////////////////////////////////////////////
      //This is the easy part.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
          
        try container.encodeIfPresent(convoId, forKey: .convoId)
        try container.encodeIfPresent(initiatorId, forKey: .initiatorId)
        try container.encodeIfPresent(recieverId, forKey: .recieverId)
        try container.encodeIfPresent(archived, forKey: .archived)

        
        try container.encodeIfPresent(initiatorMostRecentMessage, forKey: .initiatorMostRecentMessage)
        try container.encodeIfPresent(recieverMostRecentMessage, forKey: .recieverMostRecentMessage)
        
        try container.encodeIfPresent(initiatorLastActive, forKey: .initiatorLastActive)
        try container.encodeIfPresent(recieverLastActive, forKey: .recieverLastActive)
        
        try container.encodeIfPresent(initiatorLiked, forKey: .initiatorLiked)
        try container.encodeIfPresent(recieverLiked, forKey: .recieverLiked)
        
        try container.encodeIfPresent(initiatorSeen, forKey: .initiatorSeen)
        try container.encodeIfPresent(recieverSeen, forKey: .recieverSeen)
        
        try container.encodeIfPresent(initiatorNumberUnread, forKey: .initiatorNumberUnread)
        try container.encodeIfPresent(recieverNumberUnread, forKey: .recieverNumberUnread)
        
        try container.encodeIfPresent(messages, forKey: .messages)
        try container.encodeIfPresent(totalMessages, forKey: .totalMessages)
        try container.encodeIfPresent(totalCharacters, forKey: .totalCharacters)
        try container.encodeIfPresent(totalExchanges, forKey: .totalExchanges)
    }
      
    func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? FriendshipObject {
          return self.convoId == object.convoId
        }
        return false
    }
      
    
}

