//
//  Structs.swift
//  Mac Daddy
//
//  Created by Linda Chen on 1/22/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation

///////❤️ 🧡 💛 💚 💙 💜 UPDATE USER OBJECT INFORMATION HERE ❤️ 🧡 💛 💚 💙 💜


struct Friend {
    //Identifying Info
    var uid = ""
    var organization = ""
    var email = ""
    var name = ""
    var macStatus = ""
    var grade = ""
    
    //Reference Info
    var convoID = ""
    var anon = "1"
    var weight = 0
    var active = "0"
    var lastActive = "0"
}

struct DownloadedUser {
    //Basically just a friend with additional info:
    var friendInfo = Friend()
    var secondaryA = ""
    
}

struct Convo {
    var friendUID = ""
    var lastChat = ""
    var seen = ""
}




