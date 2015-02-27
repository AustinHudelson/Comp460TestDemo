//
//  AppWarpHelper.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit


/*
    Program flow (as of 2/27/15):
        - LobbyViewController -> AppWarpHelper.initializeWarp()
        - LobbyViewController -> AppWarpHelper.connectWithAppWarpWithUserName()

        - AppWarpHelper.connectWithAppWarpWithUserName() -> ConnectionListener.onConnectDone()

        - ConnectionListener.onConnectDone() -> RoomListener.onJoinRoomDone()

        - RoomListener.onJoinRoomDone() -> RoomListener.onSubscribeRoomDone()
*/
class AppWarpHelper: NSObject
{
    var api_key = "8f4823c2a1bca11bb4ad1349d127b62a312481af36cc74cda1994f9ca6564857"
    var secret_key = "c36ad65cbc48eb1df497ee91ccac5a19693ba83d6ac4b72d2aa537f563a94069"
    var roomId: String = "1506717553"
    var enemyName: String = ""
    //Player name is defined in ConnectWithAppWarpWithUserName and is identicle to the User name
    var playerName: String = ""
    var userName_list: NSMutableArray = [] // used to store the list of users currently in room
    var lobby: LobbyViewController? = nil
    
    var gameScene: GameScene? = nil
    var host: String? = nil
    
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
            // can only call WarpClient.getInstance() after the initializeWarp() function is called
            WarpClient.getInstance().connectWithUserName(userName)
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
//        println(data)
        if let convertedData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &error) {
            /*
                send over the converted data if conversion is success
            */
            var error = WarpClient.getInstance().getConnectionState()
            if error == 0 {
                // error = 0 means success in getting connection state
                println("Sending msg (\(convertedData.length) bytes) ...")
                WarpClient.getInstance().sendUpdatePeers(convertedData)
            } else {
                println("!!!WARNING: Error in sending msg (\(convertedData.length) bytes)!!!!") // print data's number of bytes
                println("!!!Error code: \(error)!!!")
            }
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
        println("Received data (\(data.length) bytes)")
        
        var recvDict: Dictionary<String, Array<Dictionary<String, AnyObject>>> = [:]
        
        var error: NSError?
        /* Convert received data back to Swift Objects */
        if let recvData: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) {
            
            if let outerDict = recvData as? Dictionary<String, AnyObject> {
                for (key: String, blob1: AnyObject) in outerDict {
                    recvDict[key] = [] // initialize our empty array
                    
                    if let arrayOfObjects = blob1 as? Array<AnyObject> {
                        for blob2 in arrayOfObjects {
                            if let object = blob2 as? Dictionary<String, AnyObject> {
                                recvDict[key]!.append(object)
                            }
                        }
                    }
                }
            }
            println(recvDict)
            
            gameScene!.updateGameState(recvDict)
        } else {
            println("!!!Error in converting recv data!!!")
            println(error!)
        }
    }
    
    
    /* ======= Lobby and designate host stuff ========= */
    func updateUserList() {
        lobby!.updateUserList()
    }
    
    /*
        Send a msg to AppWarp to tell everyone to start the game.
        The game won't start until everyone receives this message.
    */
    func sendStartGame() {
        var startGameMsg: String = "Start Game!"
        var data = startGameMsg.dataUsingEncoding(NSUTF8StringEncoding)
        WarpClient.getInstance().sendUpdatePeers(data)
    }
    
    /*
        This function is the one that actually tells everyone to segue to GameViewController.
        It should only be called when 
    */
    func startGame() {
        println("AppWarpHelper startGame()")
        lobby!.performSegueWithIdentifier("gameSegue", sender: nil)
    }
}
