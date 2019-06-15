//
//  FirebaseConstants.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/9/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/// Alias for the response type
public typealias RawJSON = [String : Any]
public typealias RawJSONArray = [RawJSON]

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// This class makes it easier to reference the database.
//////////////////////////////////////////////////
//////////////////////////////////////////////////

class NetworkConstants {
    
    // MARK: - Variables
    let realtimeRef = Database.database().reference()
    let firestoreRef = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    // Firebase Tables Names
    private let users = "Users"
    private let userObjects = "UserObjects"
    
    
    // MARK: - Functions
    func usersPath() -> CollectionReference {
        return firestoreRef.collection(users)
    }
    
    func userObjectsPath() -> CollectionReference {
        return firestoreRef.collection(userObjects)
    }
    
    func userObjectPath(userId: String) -> DocumentReference {
        return firestoreRef.collection(userObjects).document(userId)
    }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Date extensions
//////////////////////////////////////////////////
//////////////////////////////////////////////////

//Converts from date to string
extension Date {
    
    func dateToDateTimeString() -> String {
        let formatter = DateFormatter.iso8601Full
        let result = formatter.string(from: self)
        return result
    }
    
    func dateToDateString() -> String {
        let formatter = DateFormatter.yyyyMMdd
        let result = formatter.string(from: self)
        return result
    }
    
}

//Converts from string back to date
extension String {
    static func dateTimeStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter.iso8601Full
        return dateFormatter.date(from: dateString)!
    }
    
    static func dateStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter.yyyyMMdd
        return dateFormatter.date(from: dateString)!
    }
}


extension DateFormatter {
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Codable extensions
//////////////////////////////////////////////////
//////////////////////////////////////////////////

extension Encodable {
    
    func encodeModelObject() -> RawJSON? {
        //print("✨ Encoding from object to JSON...")
        let encoder = JSONEncoder()
        do {
            let objectData = try encoder.encode(self)
            
            do {
                let objectDict = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as! RawJSON
                return objectDict
            }
            catch {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
}

//Decoding syntax: let newsFeedResponse = decode(json: response, obj: FetchNewsFeed.self)

func decode<T: Decodable>(json: Any, obj: T.Type) -> T? {
    //print("⚡️ Decoding from JSON to object...")
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(obj, from: data)
            return object
        }
        catch {
            print(error)
        }
    }
    catch {
        print(error)
    }
    
    return nil
}

