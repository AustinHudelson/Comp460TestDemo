//
//  ZoneListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class ZoneListener: NSObject,ZoneRequestListener
{
    func onCreateRoomDone(roomEvent: RoomEvent)
    {
    
        if roomEvent.result == 0 //SUCCESS
        {
            var roomData:RoomData = roomEvent.roomData
            AppWarpHelper.sharedInstance.roomId = roomData.roomId
            WarpClient.getInstance().joinRoom(roomData.roomId)
        }
        else
        {
            println("onCreateRoomDone: Failed to create a room!")
            AppWarpHelper.sharedInstance.disconnectFromAppWarp() // disconnect since we could neither join nor create a room
        }
    }
    
    
    func onGetMatchedRoomsDone(event: MatchedRoomsEvent!) {
        if event.result == 0 // SUCCESS
        {
            if event.roomData.count > 0 {
                // Found our list of joinable rooms, so just join the first one in the list
                println("onGetMathcedRoomsDone: Found a joinable room!")
                let joinRoomId = event.roomData[0].roomId
                WarpClient.getInstance().joinRoom(joinRoomId)
            }
            else {
                println("onGetMatchedRoomsDone: Failed to join a room! Creating a new one dynamically instead")
                var roomProperties: Dictionary<String, AnyObject> = [:]
                roomProperties["joinable"] = true
                
                // Create a room name with roomName = playerName & maxUsers = 4
                let playerName = AppWarpHelper.sharedInstance.playerName
                AppWarpHelper.sharedInstance.createRoom(playerName, maxUsers: 4)
            }
        }
        else
        {
            println("onGetMatchedRoomsDone: Failed")
            AppWarpHelper.sharedInstance.disconnectFromAppWarp()
        }
    }
}
