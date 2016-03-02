//
//  Notification.swift
//  iosAPP
//
//  Created by MIMO on 28/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

extension NSDate {
    class var declaredDatatype: String {
        return String.declaredDatatype
    }
    class func fromDatatypeValue(stringValue: String) -> NSDate {
        return SQLDateFormatter.dateFromString(stringValue)!
    }
    var datatypeValue: String {
        return SQLDateFormatter.stringFromDate(self)
    }
}

let SQLDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    
    return formatter
}()

class Notification: NSObject {
    var notificationId = Int64()
    var firedate = NSDate()
    var recipeId = Int64()
    var taskId = Int64()
    
}