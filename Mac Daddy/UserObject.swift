//
//  UserObject.swift
//  Mac Daddy
//
//  Created by Linda Chen on 5/17/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation

//Codable means you can easily switch between object and JSON.
//Structs are value types, and classes are reference types.

//Struct: each instance keeps a unique copy of its data.
//i.e. Kevin and Linda each have Joe's contact info on their phones.
//Linda typed it in wrong, so she goes home and changes it.
//That doesn't affect Kevin's phone at all.

//Class: instances share a single copy of the data.
//Kevin and Joe are working on a Google Doc together.
//Kevin changes the title to "Hello."
//It updates on both of their screens.

//We want reference types here, since we're going to be editing a lot of information.
//However, value types are faster and safer against memory leaks, so keep that in mind.

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


class UserObject: NSObject, Codable {

    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: I. Variables
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////

    //1. Basic Information
    var uid: String?
    var email: String?
    var organization: String?
    var accountCreationDate: Date?
    var userPlatform: String?
    var credentialsProvider: String?

    //2. Onboarding information
    var termsAndCond: Bool?
    var over13: Bool?
    var setup1Complete: Bool?
    var setup2Complete: Bool?
    var setup3Complete: Bool?

    //3. Custom Information
    var firstName: String?
    var lastName: String?
    var fullName: String?
    var profilePicUrl: String?
    var grade: String?
    var status: String?
    var venmo: String?

    //4. Realtime Information
    var currentMatchID: String?
    var active: Bool?
    var lastActive: Date?
    var latitude: Double?
    var longitude: Double?
    var message: String?

    //5. Stats information
    //////////////////////////////////
    //////// ** STATS KEY *** ////////
    //////////////////////////////////
    // score =
    // level =
    // networkScore = total unique interests across all of your friends
    // streak = number of days in a row that you've used the app
    // totalPairingsInitiated = total number of times you've initiated new pairings
    // totalPairingsReceived = total number of times you've had incoming pairings
    // totalMatches =
    // totalLikes =
    // totalActiveDays =
    //////////////////////////////////
    var score: Int?
    var highScore: Int?
    var level: Int?
    var networkScore: Int?
    var streak: Int?
    var maxStreak: Int?
    var totalPairings: Int?
    var totalMatches: Int?
    var totalLikes: Int?
    var totalActiveDays: Int?
    var activeDays: [Date]?

    //6. List information
    var friendUids: [String]?
    var friendshipUids: [String]?
    var communities: [String]?
    var interests: [String]?
    var majors: [String]?


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
        case accountCreationDate
        case userPlatform
        case credentialsProvider

        //2. Onboarding information
        case termsAndCond
        case over13
        case setup1Complete
        case setup2Complete
        case setup3Complete

        //3. Custom Information
        case firstName
        case lastName
        case fullName
        case profilePicUrl
        case grade
        case status
        case venmo

        //4. Realtime Information
        case currentMatchID
        case active
        case lastActive
        case latitude
        case longitude
        case message

        //5. Stats information
        case score
        case highScore
        case level
        case networkScore
        case streak
        case maxStreak
        case totalPairings
        case totalMatches
        case totalLikes
        case totalActiveDays
        case activeDays

        //6. List information
        case friendUids
        case friendshipUids
        case communities
        case interests
        case majors
    }

    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    // MARK: III. Normal Initialization
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    init(uid: String, email: String) {
        super.init()
        self.uid = uid
        self.email = email
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
        //accountCreationDate = try container.decodeIfPresent(DateFormatter.self, forKey: .accountCreationDate)
        userPlatform = try container.decodeIfPresent(String.self, forKey: .userPlatform)
        credentialsProvider = try container.decodeIfPresent(String.self, forKey: .credentialsProvider)
        
        //Convert the date string into a date object.
        let accountCreationDateString = try container.decode(String.self, forKey: .accountCreationDate)
        let dateFormatter = DateFormatter.yyyyMMdd
        if let date = dateFormatter.date(from: accountCreationDateString) {
            accountCreationDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .accountCreationDate,
                                                   in: container,
                                                   debugDescription: "Account creation date string does not match format expected by formatter.")
        }
        
        
        
        //2. Onboarding information
        termsAndCond = try container.decodeIfPresent(Bool.self, forKey: .termsAndCond)
        over13 = try container.decodeIfPresent(Bool.self, forKey: .over13)
        setup1Complete = try container.decodeIfPresent(Bool.self, forKey: .setup1Complete)
        setup2Complete = try container.decodeIfPresent(Bool.self, forKey: .setup2Complete)
        setup3Complete = try container.decodeIfPresent(Bool.self, forKey: .setup3Complete)
        
        //3. Custom Information
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        profilePicUrl = try container.decodeIfPresent(String.self, forKey: .profilePicUrl)
        grade = try container.decodeIfPresent(String.self, forKey: .grade)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        venmo = try container.decodeIfPresent(String.self, forKey: .venmo)
        
        //4. Realtime Information
        currentMatchID = try container.decodeIfPresent(String.self, forKey: .currentMatchID)
        active = try container.decodeIfPresent(Bool.self, forKey: .active)
        //lastActive = try container.decodeIfPresent(DateFormatter.self, forKey: .lastActive)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        
        //Convert the date string into a date object.
        let lastActiveDateString = try container.decode(String.self, forKey: .lastActive)
        let dateTimeFormatter = DateFormatter.iso8601Full
        if let date = dateTimeFormatter.date(from: lastActiveDateString) {
            lastActive = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .accountCreationDate,
                                                   in: container,
                                                   debugDescription: "Last active date string does not match format expected by formatter.")
        }
        
        //5. Stats information
        score = try container.decodeIfPresent(Int.self, forKey: .score)
        highScore = try container.decodeIfPresent(Int.self, forKey: .highScore)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
        networkScore = try container.decodeIfPresent(Int.self, forKey: .networkScore)
        streak = try container.decodeIfPresent(Int.self, forKey: .streak)
        maxStreak = try container.decodeIfPresent(Int.self, forKey: .maxStreak)
        totalPairings = try container.decodeIfPresent(Int.self, forKey: .totalPairings)
        totalMatches = try container.decodeIfPresent(Int.self, forKey: .totalMatches)
        totalLikes = try container.decodeIfPresent(Int.self, forKey: .totalLikes)
        totalActiveDays = try container.decodeIfPresent(Int.self, forKey: .totalActiveDays)
        activeDays = try container.decodeIfPresent(Array.self, forKey: .activeDays)
        
        //6. List information
        friendUids = try container.decodeIfPresent(Array.self, forKey: .friendUids)
        friendshipUids = try container.decodeIfPresent(Array.self, forKey: .friendshipUids)
        communities = try container.decodeIfPresent(Array.self, forKey: .communities)
        interests = try container.decodeIfPresent(Array.self, forKey: .interests)
        majors = try container.decodeIfPresent(Array.self, forKey: .majors)
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
        try container.encodeIfPresent(accountCreationDate, forKey: .accountCreationDate)
        try container.encodeIfPresent(userPlatform, forKey: .userPlatform)
        try container.encodeIfPresent(credentialsProvider, forKey: .credentialsProvider)
        
        //2. Onboarding information
        try container.encodeIfPresent(termsAndCond, forKey: .termsAndCond)
        try container.encodeIfPresent(over13, forKey: .over13)
        try container.encodeIfPresent(setup1Complete, forKey: .setup1Complete)
        try container.encodeIfPresent(setup2Complete, forKey: .setup2Complete)
        try container.encodeIfPresent(setup3Complete, forKey: .setup3Complete)
        
        //3. Custom Information
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(profilePicUrl, forKey: .profilePicUrl)
        try container.encodeIfPresent(grade, forKey: .grade)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(venmo, forKey: .venmo)
        
        //4. Realtime Information
        try container.encodeIfPresent(currentMatchID, forKey: .currentMatchID)
        try container.encodeIfPresent(active, forKey: .active)
        try container.encodeIfPresent(lastActive, forKey: .lastActive)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(message, forKey: .message)
        
        //5. Stats information
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(highScore, forKey: .highScore)
        try container.encodeIfPresent(level, forKey: .level)
        try container.encodeIfPresent(networkScore, forKey: .networkScore)
        try container.encodeIfPresent(streak, forKey: .streak)
        try container.encodeIfPresent(maxStreak, forKey: .maxStreak)
        try container.encodeIfPresent(totalPairings, forKey: .totalPairings)
        try container.encodeIfPresent(totalMatches, forKey: .totalMatches)
        try container.encodeIfPresent(totalLikes, forKey: .totalLikes)
        try container.encodeIfPresent(totalActiveDays, forKey: .totalActiveDays)
        try container.encodeIfPresent(activeDays, forKey: .activeDays)

        //6. List information
        try container.encodeIfPresent(friendUids, forKey: .friendUids)
        try container.encodeIfPresent(friendshipUids, forKey: .friendshipUids)
        try container.encodeIfPresent(communities, forKey: .communities)
        try container.encodeIfPresent(interests, forKey: .interests)
        try container.encodeIfPresent(majors, forKey: .majors)

    }
    
    func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? UserObject {
            return self.uid == object.uid
        }
        return false
    }
    
}


