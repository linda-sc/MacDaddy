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

