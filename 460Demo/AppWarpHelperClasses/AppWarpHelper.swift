//
//  AppWarpHelper.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit


class AppWarpHelper: NSObject
{

    var api_key = "8f4823c2a1bca11bb4ad1349d127b62a312481af36cc74cda1994f9ca6564857"
    var secret_key = "c36ad65cbc48eb1df497ee91ccac5a19693ba83d6ac4b72d2aa537f563a94069"
    var roomId = "1506717553"
    var enemyName: String = ""
    //Player name is defined in ConnectWithAppWarpWithUserName and is identicle to the User name
    var playerName: String = ""
    var connected: Bool = false // variable used to check if we've established connection. This needs to be true b4 we actually send stuff
    
    var gameViewController: GameViewController? = nil
    var gameScene: GameScene? = nil
    
    class var sharedInstance:AppWarpHelper{
        struct Static{
            static var instance:AppWarpHelper?
            static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token){
                Static.instance = AppWarpHelper()
            }
            return Static.instance!
    }

    func initializeWarp()
    {
        WarpClient.initWarp(api_key, secretKey: secret_key)
        var warpClient:WarpClient = WarpClient.getInstance()
        warpClient.enableTrace(true)
        warpClient.setRecoveryAllowance(60);
        
        var connectionListener: ConnectionListener = ConnectionListener()
        warpClient.addConnectionRequestListener(connectionListener)
        
        var zoneListener: ZoneListener = ZoneListener()
        warpClient.addZoneRequestListener(zoneListener)
        
        var notificationListener:NotificationListener = NotificationListener()
        warpClient.addNotificationListener(notificationListener)
        
        var roomListener: RoomListener = RoomListener()
        warpClient.addRoomRequestListener(roomListener)
    }
    
    func connectWithAppWarpWithUserName(userName:String)
    {
        playerName = userName
        var uNameLength = userName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if uNameLength>0
        {
            var warpClient:WarpClient = WarpClient.getInstance()
            warpClient.connectWithUserName(userName)
        }
    }
    
    /*
        Call this function when you need to send a msg over the network
        - Params:
            data: Dictionary<String, Array<AnyObject>>
                - Eg. a data that contains units & orders to each unit might look like this
                    data = {
                        "Units":
                            [Unit(player1),
                                Unit(player2),
                                Unit(enemy1),
                                Unit(enemey2)],
                        "Order":
                            [Order(player1, Move(location)),
                                Order(player2, Attack(enemy1))
                            ]
                    }
    */
    func sendUpdate(data: Dictionary<String, AnyObject>) {
        var error: NSError? // Used to store error msgs in case when error occured during serialization to JSON
        
        /*
            options = 0 here b/c we wanna send a data that's as compact as possible
                - Can be set to NSJSONWritingOPtions.PrettyPrinted if you want the resulting JSON file to be human reable
        */
        println(data)
        if let convertedData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &error) {
            /*
                send over the converted data if conversion is success
            */
            println(WarpClient.getInstance().getConnectionState())
            if WarpClient.getInstance().getConnectionState() == 0 {
                println("Sending msg...")
                WarpClient.getInstance().sendUpdatePeers(convertedData)
            } else {
                println("Error in sending msg!")
                println("data size: \(convertedData.length) bytes") // print number of bytes of the data
            }
        } else {
            /*
                print error msg if convertion failed
            */
            println("Error in sending msg!")
            println(error!)
            return
        }
    }
    
    /*
        Call this function when you need to receive a msg from the network
        - Params:
            data: NSData
                - This should be a JSON serialized data
            - Converts the JSON data & its corresponding dictionary as "JSON" object (see sendUpate()'s comments for an example of a data) & calls gameScene.updateGameState
            - Even though the returned object is a "JSON" object, its use is similar to a dictionary
                - Eg. usage, assuming the data sent is the example from sendUpdate():
                    let unit_list = JSON["Units"].arrayObject
                    // unit_list is now [Unit(player1), Unit(player2), Unit(enemy1), Unit(enemey2)],
    */
    func recvUpdate(data: NSData) {
        let recvData: JSON = JSON(data)
        gameScene!.updateGameState(recvData)
    }
    
    
    func updatePlayerDataToServer(dataDict:NSMutableDictionary)
    {
        //if let y = dataDict as? String
        //{
        //    return
        //}
        
        var convertedData = NSJSONSerialization.dataWithJSONObject(dataDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        //var convertedData = NSPropertyListSerialization.dataWithPropertyList(dataDict, format: NSPropertyListFormat.XMLFormat_v1_0, options: 0, error: nil)
        
        if convertedData == nil
        {
            return
        }
        
        if WarpClient.getInstance().getConnectionState()==0
        {
            println("updatePlayerDataToServer")
            WarpClient.getInstance().sendUpdatePeers(convertedData)
        }
    }
    
    func receivedEnemyStatus(data:NSData)
    {
        println("receivedEnemyStatus...1")
        println(data)
        
        
        
        println("receivedEnemyStatus...2")
            
        var error: NSErrorPointer? = nil
        var errortwo: NSError?
        var propertyListFormat:NSPropertyListFormat? = nil
        //var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableContainers, error:error!) as NSDictionary
        var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:&errortwo) as NSDictionary
        //var responseDict: NSDictionary = NSPropertyListSerialization.propertyListWithData(data, options: 0, error: nil) as NSDictionary
            
        println(responseDict)
        println(errortwo?.debugDescription)
        //gameScene!.updateEnemyStatus(responseDict)
        

        println("receivedEnemyStatus...3")
        
        
        gameScene!.updateEnemyStatus(responseDict)
//        if enemyName.isEmpty
//        {
//            var userName : (String!) = responseDict.objectForKey("userName") as String
//            let isEqual = playerName.hasPrefix(userName)
//            if !isEqual
//            {
//                enemyName = responseDict.objectForKey("userName") as String
//                gameScene!.updateEnemyStatus(responseDict)
//            }
//        }
//        else
//        {
//            var userName : (String!) = responseDict.objectForKey("userName") as String
//            let isEqual = enemyName.hasPrefix(userName)
//            if !isEqual
//            {
//                
//            }
//        }
    }
}
