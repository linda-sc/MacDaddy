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
import Firebase

class FriendshipObject: NSObject, Codable {
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: I. Variables
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////

    var convoId: String?
    var members: [String]?
    var initiatorId: String?
    var recieverId: String?
    var archived: Bool?
    var anon: Bool?
    
    var initiator: UserObject?
    var reciever: UserObject?
    
    var initiatorAvatar: AvatarObject?
    var recieverAvatar: AvatarObject?

    var mostRecentMessage: String?
    var initiatorMostRecentMessage: String?
    var recieverMostRecentMessage: String?
    
    var lastActive: Date?
    var initiatorLastActive: Date?
    var recieverLastActive: Date?
    
    var initiatorActive: Bool?
    var recieverActive: Bool?
    
    var initiatorLiked: Bool?
    var recieverLiked: Bool?
    
    var initiatorSeen: Bool?
    var recieverSeen: Bool?
    
    var initiatorNumberUnread: Int?
    var recieverNumberUnread: Int?
    
    var initiatorTyping: Bool?
    var recieverTyping: Bool?

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
        case members
        case initiatorId
        case recieverId
        case archived
        case anon
        
        case initiator
        case reciever
        
        case initatorAvatar
        case recieverAvatar
        
        case mostRecentMessage
        case initiatorMostRecentMessage
        case recieverMostRecentMessage
        
        case lastActive
        case initiatorLastActive
        case recieverLastActive
        
        case initiatorActive
        case recieverActive
        
        case initiatorLiked
        case recieverLiked
        
        case initiatorSeen
        case recieverSeen
        
        case initiatorNumberUnread
        case recieverNumberUnread
        
        case initiatorTyping
        case recieverTyping
        
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
        self.anon = true
        self.lastActive = Date()
        
        self.members = [String]()
        self.members?.append(initiatorId)
        self.members?.append(recieverId)
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
        members = try container.decodeIfPresent([String].self, forKey: .members)
        initiatorId = try container.decodeIfPresent(String.self, forKey: .initiatorId)
        recieverId = try container.decodeIfPresent(String.self, forKey: .recieverId)
        archived = try container.decodeIfPresent(Bool.self, forKey: .archived)
        anon = try container.decodeIfPresent(Bool.self, forKey: .anon)
        
        initiatorAvatar = try container.decodeIfPresent(AvatarObject.self, forKey: .initatorAvatar)
        recieverAvatar = try container.decodeIfPresent(AvatarObject.self, forKey: .recieverAvatar)
        
        mostRecentMessage = try container.decodeIfPresent(String.self, forKey: .mostRecentMessage)
        initiatorMostRecentMessage = try container.decodeIfPresent(String.self, forKey: .initiatorMostRecentMessage)
        recieverMostRecentMessage = try container.decodeIfPresent(String.self, forKey: .recieverMostRecentMessage)

        
        //Convert the date strings into a date objects
          let lastActiveString = try container.decodeIfPresent(String.self, forKey: .lastActive)
          let dateTimeFormatter = DateFormatter.iso8601Full
          if let lastActiveDate = dateTimeFormatter.date(from: lastActiveString ?? "") {
              lastActive = lastActiveDate
          } else {
              if lastActiveString != nil {
                  throw DecodingError.dataCorruptedError(forKey: .lastActive,
                                                         in: container,
                                                         debugDescription: "lastActive date string does not match format expected by formatter.")
              }
          }
        
        //Convert the date strings into a date objects
        let initiatorLastActiveString = try container.decodeIfPresent(String.self, forKey: .initiatorLastActive)
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
        
        initiatorActive = try container.decodeIfPresent(Bool.self, forKey: .initiatorActive)
        recieverActive = try container.decodeIfPresent(Bool.self, forKey: .recieverActive)
        
        initiatorLiked = try container.decodeIfPresent(Bool.self, forKey: .initiatorLiked)
        recieverLiked = try container.decodeIfPresent(Bool.self, forKey: .recieverLiked)

        initiatorSeen = try container.decodeIfPresent(Bool.self, forKey: .initiatorSeen)
        recieverSeen = try container.decodeIfPresent(Bool.self, forKey: .initiatorSeen)
 
        initiatorNumberUnread = try container.decodeIfPresent(Int.self, forKey: .initiatorNumberUnread)
        recieverNumberUnread = try container.decodeIfPresent(Int.self, forKey: .recieverNumberUnread)
        
        initiatorTyping = try container.decodeIfPresent(Bool.self, forKey: .initiatorTyping)
        recieverTyping = try container.decodeIfPresent(Bool.self, forKey: .recieverTyping)

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
        try container.encodeIfPresent(members, forKey: .members)
        try container.encodeIfPresent(initiatorId, forKey: .initiatorId)
        try container.encodeIfPresent(recieverId, forKey: .recieverId)
        try container.encodeIfPresent(initiatorAvatar, forKey: .initatorAvatar)
        try container.encodeIfPresent(recieverAvatar, forKey: .recieverAvatar)
        try container.encodeIfPresent(archived, forKey: .archived)
        try container.encodeIfPresent(anon, forKey: .anon)

        try container.encodeIfPresent(mostRecentMessage, forKey: .mostRecentMessage)
        try container.encodeIfPresent(initiatorMostRecentMessage, forKey: .initiatorMostRecentMessage)
        try container.encodeIfPresent(recieverMostRecentMessage, forKey: .recieverMostRecentMessage)
        
        //Convert the dates into a strings to make them JSON encodable
        let lastActiveString = lastActive?.dateToDateTimeString()
        let initiatorLastActiveString = initiatorLastActive?.dateToDateTimeString()
        let recieverLastActiveString = recieverLastActive?.dateToDateTimeString()
        
        try container.encodeIfPresent(lastActiveString, forKey: .initiatorLastActive)
        try container.encodeIfPresent(initiatorLastActiveString, forKey: .initiatorLastActive)
        try container.encodeIfPresent(recieverLastActiveString, forKey: .recieverLastActive)
        
        try container.encodeIfPresent(initiatorActive, forKey: .initiatorActive)
        try container.encodeIfPresent(recieverActive, forKey: .recieverActive)
        
        try container.encodeIfPresent(initiatorLiked, forKey: .initiatorLiked)
        try container.encodeIfPresent(recieverLiked, forKey: .recieverLiked)
        
        try container.encodeIfPresent(initiatorSeen, forKey: .initiatorSeen)
        try container.encodeIfPresent(recieverSeen, forKey: .recieverSeen)
        
        try container.encodeIfPresent(initiatorNumberUnread, forKey: .initiatorNumberUnread)
        try container.encodeIfPresent(recieverNumberUnread, forKey: .recieverNumberUnread)
        
        try container.encodeIfPresent(initiatorTyping, forKey: .initiatorTyping)
        try container.encodeIfPresent(recieverTyping, forKey: .recieverTyping)
        
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


//MARK: Functions!
extension FriendshipObject {
    
    //MARK: Is seen by me
    func isSeenByMe() -> Bool {
        if let myUid = Auth.auth().currentUser?.uid ?? UserManager.shared.currentUser?.uid {
            
            if initiatorId == myUid {
                return initiatorSeen ?? true
            } else if recieverId == myUid {
                return recieverSeen ?? true
            }
        } else {
            print("My uid doesn't exist. Cannot check for unread.")
            return false
        }
        return false
    }
    
    func iAmInitiator() -> Bool {
        if let myUid = Auth.auth().currentUser?.uid ?? UserManager.shared.currentUser?.uid {
                if initiatorId == myUid {
                    return true
                }
        }
        return false
    }
 
    func iAmReceiver() -> Bool {
         if let myUid = Auth.auth().currentUser?.uid ?? UserManager.shared.currentUser?.uid {
                 if recieverId == myUid {
                     return true
                 }
         }
         return false
     }
    
}

