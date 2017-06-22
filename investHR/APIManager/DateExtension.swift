//
//  DateExtension.swift
//  investHR
//
//  Created by mac on 22/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation

extension Date
{
    var millisecondsSince1970:Int {
        return Int(Int64((self.timeIntervalSince1970 * 1000.0).rounded()))
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func getLocatDateFromMillisecods(millisecods:Double) -> String
    {
        var date1 = Date(timeIntervalSince1970: (millisecods / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date2 = dateFormatter.string(from: date1)
        
        return date2
    }
}

extension Data
{
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
