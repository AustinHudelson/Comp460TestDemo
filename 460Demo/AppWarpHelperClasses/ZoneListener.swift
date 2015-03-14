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
                println("onGetMatchedRoomsDone: Failed to find a room with the \"joinable\" property! Creating a new one dynamically instead")
                var roomProperties: Dictionary<String, AnyObject> = [:]
                roomProperties["joinable"] = true
                
                // Create a room name with roomName = playerName & maxUsers = roomMaxUsers
                let playerName = AppWarpHelper.sharedInstance.playerName
                let maxUsers = AppWarpHelper.sharedInstance.roomMaxUsers
                AppWarpHelper.sharedInstance.createRoom(playerName, maxUsers: maxUsers)
            }
        }
        else
        {
            println("onGetMatchedRoomsDone: Failed")
            AppWarpHelper.sharedInstance.disconnectFromAppWarp()
        }
    }
    
    func onDeleteRoomDone(roomEvent: RoomEvent!) {
        println("onDeleteRoomDone")
    }
}
