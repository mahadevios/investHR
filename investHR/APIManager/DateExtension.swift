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
    var millisecondsSince1970:Int
    {
        return Int(Int64((self.timeIntervalSince1970 * 1000.0).rounded()))
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    
    func getLocatDateFromMillisecods(millisecods:Double?) -> String?
    {
        guard let milSeconds = millisecods
        else
        {
          return ""
        }
        
        var date1 = Date(timeIntervalSince1970: (milSeconds / 1000.0))
        
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

extension UIColor
{
    
    class func appliedJobGreenColor() -> UIColor
    {
        // create color from string
        // ... some code
        return UIColor(colorLiteralRed: 32/255.0, green: 105/255.0, blue: 44/255.0, alpha: 1.0)
    }
    class func appBlueColor() -> UIColor
    {
        // create color from string
        // ... some code
        return UIColor(colorLiteralRed: 29/255.0, green: 123/255.0, blue:231/255.0, alpha: 1.0)
    }
   
}

class subclassedUIButton: UIButton
{
    var jobId: Int64?
    var indexPath: Int!
    var tempIndexPath: IndexPath!
    var cell:UITableViewCell!
    var cell1:UICollectionViewCell!

}

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}
