//
//  RoomListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class RoomListener: NSObject,RoomRequestListener
{
    func onJoinRoomDone(roomEvent:RoomEvent)
    {
        if roomEvent.result == 0 // SUCESS
        {
            var roomData:RoomData = roomEvent.roomData
            AppWarpHelper.sharedInstance.roomId = roomData.roomId
            WarpClient.getInstance().subscribeRoom(roomData.roomId)
            println("onJoinRoomDone Success")

            println("Joined a room:\t roomId=\(roomData.roomId!)\n \t roomOwner=\(roomData.owner!)\n \t roomName=\(roomData.name)\n \t roomMaxUsers=\(roomData.maxUsers)")

        }
        else
        {
            /*
                Failed to join the room. This probably happens when room a room is joinable because host hasnt started the game
                yet but the room is full. Therefore we should create a new room
            */
            println("onJoinRoomDone: Failed to find a room that isn't full! Creating one instead")
            let playerName = AppWarpHelper.sharedInstance.playerName
            let maxUsers = AppWarpHelper.sharedInstance.roomMaxUsers
            AppWarpHelper.sharedInstance.createRoom(playerName, maxUsers: maxUsers)
        }
    }
    
    func onSubscribeRoomDone(roomEvent: RoomEvent)
    {
        if roomEvent.result == 0 // SUCESS
        {
            println("onSubscribeRoomDone Success")
            
            /*
                Send a request to AppWarp to get live room info.
                If success, RoomListener.onGetLiveRoomInfoDone() will be called and that function
                updates AppWarpHelper.userName_list
            */
            WarpClient.getInstance().getLiveRoomInfo(AppWarpHelper.sharedInstance.roomId)
        }
        else // Failed to subscribe
        {
            println("onSubscribeRoomDone Failed")
            AppWarpHelper.sharedInstance.disconnectFromAppWarp()
        }
    }
    
    func onGetLiveRoomInfoDone(event: LiveRoomInfoEvent)
    {
        /* update the user list */
        AppWarpHelper.sharedInstance.userName_list = event.joinedUsers
        
        AppWarpHelper.sharedInstance.updateUserList()
        
    }
    func onUnSubscribeRoomDone(event: RoomEvent)
    {
        WarpClient.getInstance().leaveRoom(AppWarpHelper.sharedInstance.roomId)
    }
    func onLeaveRoomDone(roomEvent: RoomEvent!) {
        AppWarpHelper.sharedInstance.disconnectFromAppWarp()
    }
    
    func onUpdatePropertyDone(event: LiveRoomInfoEvent!) {
        println("onUpdatePropertyDone")
    }
}
