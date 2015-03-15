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

        - ConnectionListener.onConnectDone() -> ZoneListner.onGetMatchedRoomsDone()

            1. ZoneListner.onGetMatchedRoomsDone() -> RoomListner.onJoinRoomDone()
                a. RoomListner.onJoinRoomDone() -> RoomListner.onSubscribeRoomDone()
                b. RoomListner.onJoinRoomDone() -> ZoneListener.onCreateRoomDone()

            2. ZoneListner.onGetMatchedRoomsDone() -> ZoneListener.onCreateRoomDone()

        - NotificationListener.onUserJoinedRoom() -> RoomListner.onGetLiveRoomInfoDone()
*/
class AppWarpHelper: NSObject
{
    /* Austin's AppWarp key */
    var api_key = "8f4823c2a1bca11bb4ad1349d127b62a312481af36cc74cda1994f9ca6564857"
    var secret_key = "c36ad65cbc48eb1df497ee91ccac5a19693ba83d6ac4b72d2aa537f563a94069"
    var roomId: String?
    var roomMaxUsers: Int32 = 4
//   /* Robert's AppWarp key */
//    var api_key = "7eab7838469013d4378f912ce41c1dcb2801686185fc7ae48694976b9d67380f"
//    var secret_key = "e493311e8192cb2d424d16c7588e834abbbf35a7fbd0d2459d53ccc7a990ebf1"
    
    var enemyName: String = ""
    //Player name is defined in ConnectWithAppWarpWithUserName and is identicle to the User name
    var playerName: String = ""
    var userName_list: NSMutableArray = [] // used to store the list of users currently in room
    var lobby: LobbyTableViewController? = nil
    var playerClass: String = ""
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
        warpClient.setRecoveryAllowance(10);
        
        var connectionListener: ConnectionListener = ConnectionListener()
        warpClient.addConnectionRequestListener(connectionListener)
        
        var zoneListener: ZoneListener = ZoneListener()
        warpClient.addZoneRequestListener(zoneListener)
        
        var notificationListener:NotificationListener = NotificationListener()
        warpClient.addNotificationListener(notificationListener)
        
        var roomListener: RoomListener = RoomListener()
        warpClient.addRoomRequestListener(roomListener)
    }
    
    /*
        Connect to AppWarp with the given api_key & secret_key defined above
    */
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
        Create a room on AppWarp with the given roomName. This should be called after you've connected to AppWarp and see that there are no avaiable rooms to join.
        The gameStarted parameter is defaulted to false
    */
    func createRoom(roomName: String, maxUsers: Int32)
    {
        var roomProperties: Dictionary<String, AnyObject> = [:]
        roomProperties["joinable"] = true
        
        WarpClient.getInstance().createRoomWithRoomName(roomName, roomOwner: playerName, properties: roomProperties, maxUsers: maxUsers)
    }
    
    /*
        Update the room's "joinable" property to unjoinable
    */
    func updateRoomToUnjoinable()
    {
        var roomProperties: Dictionary<String, AnyObject> = [:]
        roomProperties["joinable"] = false
        
        /* We want to remove the "joinable" property so it can no longer be found as a joinable room */
        WarpClient.getInstance().updateRoom(roomId, addProperties: roomProperties, removeProperties: nil)
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
                            ],
                        "SentTime": ["3/3/15, 4:44:45 AM GMT"]
                    }
    */
    func sendUpdate(inout data: Dictionary<String, Array<AnyObject>>) {
        // add sent time
        Timer.logSendTime(&data)
        /*
        ====================================================
            Send the data
        */
        var error: NSError? // Used to store error msgs in case when error occured during serialization to JSON
        
        /*
            options = 0 here b/c we wanna send a data that's as compact as possible
                - Can be set to NSJSONWritingOPtions.PrettyPrinted if you want the resulting JSON file to be human reable
        */
        if let convertedData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &error) {
            /*
                send over the converted data if conversion is success
            */
            var error = WarpClient.getInstance().getConnectionState()
            if error == 0 {
                // error = 0 means success in getting connection state
                println("Sending msg (\(convertedData.length) bytes) ...")
                println(data)
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
        
        var recvDict: Dictionary<String, Array<AnyObject>> = [:]
        
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
                            if let timeStr = blob2 as? String {
                                recvDict[key]!.append(timeStr)
                            }
                        }
                    }
                }
            }
            
            println(recvDict)
            
            /*
                if gameScene is not initialized yet, that means this msg received is host's start game msg, so don't call gameScene.updateGameState; start the game instead.
            */
            if gameScene == nil {
                /* Print the start time and received time */
                let sentTimeStr = (recvDict["SentTime"]!)[0] as String
                var sentTime: NSDate = Timer.StrToDate(sentTimeStr)!
                var recvTime: NSDate = Timer.getCurrentTime()
                var recvTimeStr = Timer.DateToStr(recvTime)
                var diff: NSTimeInterval = Timer.diffDateNow(sentTime) // get difference between sent time and now
                println("SentTime: \(sentTimeStr); RecvTime: \(recvTimeStr); diff between SentTime & recvTime: \(diff) seconds")
                
                /* start the game */
                startGame()
            } else {
                gameScene!.updateGameState(recvDict)
            }
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
        var startGameMsg: Dictionary<String, Array<AnyObject>> = [:]
        startGameMsg["Start Game!"] = []
        sendUpdate(&startGameMsg)
    }
    
    /*
        This function is the one that actually tells everyone to segue to GameViewController.
        It should only be called when 
    */
    func startGame() {
        println("AppWarpHelper startGame()")
        
        /* if you're the host, set roomProperty to unjoinable */
        if playerName == host {
            updateRoomToUnjoinable()
        }
        
        lobby!.performSegueWithIdentifier("gameSegue", sender: nil)
    }
    
    func leaveGame(){
        WarpClient.getInstance().unsubscribeRoom(self.roomId)
        //WarpClient.getInstance().leaveRoom(self.roomId)
    }
    
    func disconnectFromAppWarp() {
        println("Disconnecting from AppWarp...")
        WarpClient.getInstance().disconnect()
    }
}
