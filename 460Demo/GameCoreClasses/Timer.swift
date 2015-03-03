//
//  Timer.swift
//  460Demo
//
//  Created by Robert Ko on 3/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

/*
    We shall assume all our NSDates and Strings that represent NSDate are of GMT time zone
*/
class Timer
{
    /*
        This func is a wrapper to get the current time.
        NSDate() returns a NSDate object initialized to the current date and time.
    */
    class func getCurrentTime() -> NSDate {
        let now: NSDate = NSDate()
        return now
    }
    
    /*
        This func converts a time (a NSDate object) to a String (with specific format) so it can be serialized as JSON
    */
    class func NSDateToStr(date: NSDate) -> String {
        let dateFormat: NSDateFormatter = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.LongStyle
        dateFormat.timeZone = NSTimeZone(abbreviation: "GMT")
        
        let dateStr: String = dateFormat.stringFromDate(date)
        return dateStr
    }
    
    /*
        This func converts a String (with a specific format) back to its time representation (a NSDate object).
        It should be used after a JSON is deserialized
    */
    class func StrToNSDate(dateStr: String) -> NSDate {
        let dateFormat: NSDateFormatter = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.LongStyle
        dateFormat.timeZone = NSTimeZone(abbreviation: "GMT")
        
        var backToDate: NSDate? = dateFormat.dateFromString(dateStr)
        
        if backToDate == nil {
            println("!!!Error in converting from String to NSDate!!!")
            println("StringToNSDate() will return the current time instead")
            
            backToDate = NSDate()
        }
        return backToDate!
    }
    
    /*
        This func returns the difference between the given date and current time, in terms of seconds.
        The standard unit of time for date objects is floating point value typed as NSTimeInterval and is expressed in seconds.
    */
    class func diffDateNow(givenDate: NSDate) -> NSTimeInterval {
        let now: NSDate = getCurrentTime()
        let diff: NSTimeInterval = now.timeIntervalSinceDate(givenDate)
        
        return diff
    }
}