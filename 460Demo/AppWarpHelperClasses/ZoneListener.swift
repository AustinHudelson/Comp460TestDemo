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
    
    // Came from WarpClient.getInstance().getRoomWithProperties
    func onGetMatchedRoomsDone(event: MatchedRoomsEvent!) {
        if event.result == 0 // SUCCESS
        {
            // If there exists at least one joinable room, populate the table
            if event.roomData.count > 0 {
                // Should be populating the GameLobby table; this is just a temporary measure
                println("---Listing joinable Rooms---")
                var roomNo: Int = 1
                for room in event.roomData {
                    let roomID: String = room.roomId!
                    let roomOwner: String = room.owner!
                    let roomMaxUsers: Int = Int(room.maxUsers!)
                    if room.userNames != nil
                    {
                        let roomCurrentUsers: Int = Int(room.userNames!.count)
                        println("Room Current Users: \(roomCurrentUsers)")
                    }
                    println("Room No.: \(roomNo)")
                    println("Room ID: \(roomID)")
                    println("Room Owner: \(roomOwner)")
                    println("Room MaxUsers: \(roomMaxUsers)")
                    
                    println("=====================")
                    
                }
            }
            else {
                println("---Can't find a joinable room!---")
            }
            
//            if event.roomData.count > 0 {
//                // Found our list of joinable rooms, so just join the first one in the list
//                println("onGetMathcedRoomsDone: Found a joinable room!")
//                let joinRoomId = event.roomData[0].roomId
//                WarpClient.getInstance().joinRoom(joinRoomId)
//            }
//            else {
//                println("onGetMatchedRoomsDone: Failed to find a room with the \"joinable\" property! Creating a new one dynamically instead")
//                
//                // Create a room name with roomName = playerName & maxUsers = roomMaxUsers
//                let playerName = AppWarpHelper.sharedInstance.playerName
//                let maxUsers = AppWarpHelper.sharedInstance.maxUsers
//                AppWarpHelper.sharedInstance.createRoom(playerName, maxUsers: maxUsers)
//            }
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
