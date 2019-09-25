//
//  Message.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/24/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    
    var id: String?
    var content: String
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    //Init from Database Query
    init(id: String, name: String, content: String) {
        self.id = id
        self.content = content
        
        sender = Sender(id: id, displayName: name)
        messageId = id
        sentDate = Date()
        kind = .text(content)
    }
    
    //Init from client
    init(user: UserObject, content: String) {
        sender = Sender(id: user.uid!, displayName: "Me")
        self.content = content
        self.messageId = ""
        sentDate = Date()
        id = nil
        self.kind = .text(content)
    }
}


extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
}
