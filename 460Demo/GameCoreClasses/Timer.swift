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
        var netClock: NetworkClock = NetworkClock.sharedNetworkClock() // network clock used to get time from ntp servers defined in 460Demo/iosNtp/ntp.hosts
        var now: NSDate = netClock.networkTime // get the network time
        return now
    }
    
    /*
        This func converts a time (a NSDate object) to a String (with specific format) so it can be serialized as JSON
    */
    class func DateToStr(date: NSDate) -> String {
        let dateFormat: NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        dateFormat.timeZone = NSTimeZone(abbreviation: "GMT")
        
        let dateStr: String = dateFormat.stringFromDate(date)
        return dateStr
    }
    
    /*
        This func converts a String (with a specific format) back to its time representation (a NSDate object).
        It should be used after a JSON is deserialized
    */
    class func StrToDate(dateStr: String) -> NSDate? {
        let dateFormat: NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        dateFormat.timeZone = NSTimeZone(abbreviation: "GMT")
        
        var backToDate: NSDate? = dateFormat.dateFromString(dateStr)
        
        if backToDate == nil {
            println("!!!Error in converting from String to NSDate!!!")
            println("StringToDate() will return nil instead")
        }
        return backToDate
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
    
    /*
        This func adds a "SentTime" entry in the given sending dictionary. Had to do this instead of putting it in AppWarpHelper.sendUpdate() to get around Swift's compile error.
        - Our sendData will look like this:
            data = {
                "Units":
                    [Unit(player1),
                        Unit(player2),
                        Unit(enemy1),
                        Unit(enemey2)],
                "Order":
                    [Order(player1, Move(location)),
                        Order(player2, Attack(enemy1))
                ],
                "SentTime": ["3/3/15, 4:44:45 AM GMT"]
            }
        - Since function arguments are immutable by default, but we want to append an entry that tells us the sent time, we need to declare the param as 'inout'
            - to call this function, which will mutate the input, you should call it with a &
    */
    class func logSendTime(inout sendData: Dictionary<String, Array<AnyObject>>) {
        /*
        ====================================================
            Append the entry ["SentTime": (curent Time)] to the given sending dictionary to log the sending time
        */
        let nowStr: String = Timer.DateToStr(Timer.getCurrentTime())
        sendData["SentTime"] = Array<AnyObject>()
        sendData["SentTime"]!.append(nowStr)
    }
}