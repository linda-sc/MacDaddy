//
//  CodableExtensions.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/16/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation

/// Alias for the response type
public typealias RawJSON = [String : Any]
public typealias RawJSONArray = [RawJSON]

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Codable extensions
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//MARK: Encoding Model Objects
extension Encodable {
    
    func encodeModelObject() -> RawJSON? {
        //print("✨ Encoding from object to JSON...")
        let encoder = JSONEncoder()
        do {
            let objectData = try encoder.encode(self)
            do {
                let objectDict = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as! RawJSON
                if (!JSONSerialization.isValidJSONObject(objectData)) {
                    print("Encoding error: is not a valid json object")
                }
                
                return objectDict
            } catch {
                return nil
            }
        } catch {
            return nil
        }
    }
    
}


extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}



//MARK: Decoding Model Objects

//Decoding syntax: let newsFeedResponse = decode(json: response, obj: FetchNewsFeed.self)

func decode<T: Decodable>(json: Any, obj: T.Type) -> T? {
    //print("⚡️ Decoding from JSON to object...")
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(obj, from: data)
            return object
        } catch {
            print(error)
        }
    } catch {
        print(error)
    }
    return nil
}




//////////////////////////////////////////////////
//////////////////////////////////////////////////
//MARK: Date Extensions

// Note: Date conforms to comparable protocol
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
//MARK: Turning time interval into traditional time
//////////////////////////////////////////////////
//////////////////////////////////////////////////

extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
    
    var stringTimeAgo: String {
        if hours != 0 {
            return "\(hours) hours ago"
        } else if minutes != 0 {
            return "\(minutes) minutes ago"
        } else {
            return "\(seconds) seconds ago"
        }
    }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Codable extensions
//////////////////////////////////////////////////
//////////////////////////////////////////////////

//MARK: Getting time elapsed interval as a string

extension Date {

func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())

    if let year = interval.year, year > 0 {
        return year == 1 ? "\(year)" + " " + "year ago" :
            "\(year)" + " " + "years ago"
    } else if let month = interval.month, month > 0 {
        return month == 1 ? "\(month)" + " " + "month ago" :
            "\(month)" + " " + "months ago"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "\(day)" + " " + "day ago" :
            "\(day)" + " " + "days ago"
    } else if let hour = interval.hour, hour > 0 {
          return hour == 1 ? "\(hour)" + " " + "hour ago" :
              "\(hour)" + " " + "hours ago"
    } else if let minute = interval.minute, minute > 0 {
          return minute == 1 ? "\(minute)" + " " + "minute ago" :
              "\(minute)" + " " + "minutes ago"
    } else {
        return "a moment ago"

    }

}
}
