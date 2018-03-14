//
//  Structs.swift
//  Mac Daddy
//
//  Created by Linda Chen on 1/22/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import Foundation

struct Friend {
    //Candidate Info
    var uid = ""
    var convoID = ""
    var name = ""
    var anon = "y"
    
    //Sorting Info
    var macStatus = ""
    var grade = ""
    var weight = 0
    
    //Status Info
    var active = "n"
    var lastActive = "n"
}

struct Convo {
    var friendUID = ""
    var lastChat = ""
    var seen = ""
}

struct DownloadedUser {
    //Candidate Info
    var uid = ""
    var convoID = ""
    var name = ""
    var anon = "y"
    
    //Sorting Info
    var macStatus = ""
    var grade = ""
    var weight = 0
    
    //Status Info
    var active = "n"
    var lastActive = "n"
    
    //Basically just a friend with additional info:
    var secondaryA = ""
    
}



