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
//    /* Austin's AppWarp key */
//    var api_key = "8f4823c2a1bca11bb4ad1349d127b62a312481af36cc74cda1994f9ca6564857"
//    var secret_key = "c36ad65cbc48eb1df497ee91ccac5a19693ba83d6ac4b72d2aa537f563a94069"
    var roomId: String?
    var maxUsers: Int32 = 3 // max user per room
   /* Robert's AppWarp key */
    var api_key = "7eab7838469013d4378f912ce41c1dcb2801686185fc7ae48694976b9d67380f"
    var secret_key = "e493311e8192cb2d424d16c7588e834abbbf35a7fbd0d2459d53ccc7a990ebf1"
    
    var enemyName: String = ""
    var playerName: String = ""
    var deviceName: String = UIDevice.currentDevice().identifierForVendor.UUIDString
    var userName_list: NSMutableArray = [] // used to store the list of users currently in room
    var lobby: LobbyViewController? = nil
    var playerClass: String = ""
    //var gameScene: GameScene? = nil
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
    
    var initializeWarpRan = false
    
    func initializeWarp()
    {
        if initializeWarpRan == true {
            return
        }
        initializeWarpRan = true
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
    
    
    func sendUpdate(convertedData: NSData) {
        var error = WarpClient.getInstance().getConnectionState()
        if error == 0 {
            // error = 0 means success in getting connection state
            println("Sending msg (\(convertedData.length) bytes) ...")
            WarpClient.getInstance().sendUpdatePeers(convertedData)
        } else {
            println("!!!WARNING: Error in sending msg (\(convertedData.length) bytes)!!!!") // print data's number of bytes
            println("!!!Error code: \(error)!!!")
            
        }
    }
    
    /*
        Call this function when you need to receive a msg from the network
        - Params:
            data: NSData
                - This should be a JSON serialized data
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
            
            NetworkManager.processRecvMsg(recvDict)
        } else {
            println("!!!Error in converting recv data!!!")
            println(error!)
        }
    }
    
    
    /* ======= Lobby and designate host stuff ========= */
    func configLobbyView() {
        if let lobby = self.lobby {
            lobby.configLobbyView()
        }
    }
    
    func leaveGame(){
        //WarpClient.getInstance().unsubscribeRoom(self.roomId)
        WarpClient.getInstance().leaveRoom(self.roomId)
    }
    
    /*
        This function is normally called from RoomListener.onUnSubscribeRoomDone()
        Otherwise it'll be called when there's error connecting / creating room..etc
    */
    func disconnectFromAppWarp() {
        println("Disconnecting from AppWarp...")
        self.lobby = nil
        WarpClient.getInstance().disconnect()
    }
}
