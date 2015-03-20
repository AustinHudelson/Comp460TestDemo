import Foundation

/*
    An helper class that manages sending and receiving msgs over AppWarp.
    This class sends & recevies data using a specific dictionary format (Dictionary<String, Array<AnyObject>>).
    An example of a dictionary that is passed over the network looks like this:
        data = {
            "Units":
                [Unit(player1), Unit(player2), Unit(enemy1), Unit(enemey2)]
            "Order":
                [Order(player1, Move(location)), Order(player2, Attack(enemy1))]
            "SentTime":
                ["3/3/15, 4:44:45 AM GMT"]
        }

    For sending, user should construct his own send dictionary.
    For receving, processRecvMsg() should be modified to call the right functions, and the corresponding
    object that needs the received data should also be modified (most likely Game.swift)

*/
class NetworkManager {
    /*
        Call this function when you need to send a msg over the network
        - Params:
            sendDict: Dictionary<String, Array<AnyObject>>
    */
    class func sendMsg(inout sendDict: Dictionary<String, Array<AnyObject>>) {
        // add sent time
        Timer.logSendTime(&sendDict)
        /*
            ====================================================
            Convert the data to JSON & call AppWarpHelper's sendUpdate()
        */
        var error: NSError? // Used to store error msgs in case when error occured during serialization to JSON
        
        /*
            options = 0 here b/c we wanna send a data that's as compact as possible
            - Can be set to NSJSONWritingOPtions.PrettyPrinted if you want the resulting JSON file to be human reable
        */
        if let convertedData = NSJSONSerialization.dataWithJSONObject(sendDict, options: NSJSONWritingOptions(0), error: &error) {
            /*
                send over the converted data if conversion is success
            */
            AppWarpHelper.sharedInstance.sendUpdate(convertedData)

        } else {
            /*
            print error msg if convertion failed
            */
            println("!!!WARNING: Error in converting the msg to be sent!!!!")
            println(error!)
            return
        }
    }
    
    /*
        This function is called directly from AppWarpHelper.recvUpdate().
        Add to this function when you want to do new things with the recevied message
    */
    class func processRecvMsg(recvDict: Dictionary<String, Array<AnyObject>>) {
        for (key: String, arrayOfObjects: Array<AnyObject>) in recvDict {
            switch key {
                case "Start Game!":
                    // Putting this block of code here for now. Maybe should make a function for it somewhere
                    /* Print the start time and received time */
                    let sentTimeStr = (recvDict["SentTime"]!)[0] as String
                    var sentTime: NSDate = Timer.StrToDate(sentTimeStr)!
                    var recvTime: NSDate = Timer.getCurrentTime()
                    var recvTimeStr = Timer.DateToStr(recvTime)
                    var diff: NSTimeInterval = Timer.diffDateNow(sentTime) // get difference between sent time and now
                    println("SentTime: \(sentTimeStr); RecvTime: \(recvTimeStr); diff between SentTime & recvTime: \(diff) seconds")
                    
                    /* start the game */
                    AppWarpHelper.sharedInstance.startGame()
                
                /* === Game related cases === */
                case "Units", "SyncPlayer", "SyncEnemies":
                    Game.global.updateUnits(arrayOfObjects)
                case "Orders":
                    Game.global.updateUnitOrders(arrayOfObjects)
                case "SentTime":
                    // Putting this block of code here for now. Maybe should make a function for it somewhere
                    // Have to put the sent time in an array (even though it contains only 1 element) to get around Swift's compile error
                    for object in arrayOfObjects {
                        let sentTimeStr = object as String
                        var sentTime: NSDate = Timer.StrToDate(sentTimeStr)!
                        var recvTime: NSDate = Timer.getCurrentTime()
                        var recvTimeStr = Timer.DateToStr(recvTime)
                        var diff: NSTimeInterval = Timer.diffDateNow(sentTime) // get difference between sent time and now
                        println("SentTime: \(sentTimeStr); RecvTime: \(recvTimeStr); diff between SentTime & recvTime: \(diff) seconds")
                    }
                default:
                    // Placeholder default
                    println("proccesRecvMsg found a key \"\(key)\" in recvDict that's not yet implemented")
            }
        }
    }
    

}
