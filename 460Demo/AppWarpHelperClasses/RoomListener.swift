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
    //Keeps track of the last time a room was created
    var lastCreatedRoomTime: NSDate = Timer.getCurrentTime()
    //True if this Room Listener has never created a room.
    var firstRoom = true
    
    
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
                yet but the room is full. Therefore we should create a new room.
                The time check is to make sure that you do not try to create more than 1 room every 3 seconds to not bog down the appwarp servers.
            */
            if firstRoom == true || Timer.diffDateNow(lastCreatedRoomTime) < NSTimeInterval(3.0){
                println("onJoinRoomDone: Failed to find a room that isn't full! Creating one instead")
                let playerName = AppWarpHelper.sharedInstance.playerName
                let maxUsers = AppWarpHelper.sharedInstance.roomMaxUsers
                //Update variables for last created room check
                firstRoom = false
                lastCreatedRoomTime = Timer.getCurrentTime()
                AppWarpHelper.sharedInstance.createRoom(playerName, maxUsers: maxUsers)
            } else {
                println("Attempted to create 2 rooms within 3 seconds of one another. Exiting")
                AppWarpHelper.sharedInstance.disconnectFromAppWarp()
            }
            
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
        println("getting live info")
        /* update the user list */
        AppWarpHelper.sharedInstance.userName_list = event.joinedUsers
        
        
        /* If gameScene is nil that means we're in the lobby, so configure the lobby view */
        if AppWarpHelper.sharedInstance.gameScene == nil {
            AppWarpHelper.sharedInstance.configLobbyView()
        }
        else {
            let userName_list = AppWarpHelper.sharedInstance.userName_list
            // We're requesting live room info when host leaves the room, so designate new host
            let oldHost = AppWarpHelper.sharedInstance.host
            
            if userName_list.count <= 0
            {
                println("Deleting room")
                WarpClient.getInstance().deleteRoom(event.roomData.roomId)
            }
            
            if (!userName_list.containsObject(oldHost!)) && (userName_list.count > 0) {
                let newHost = userName_list[0] as String
                AppWarpHelper.sharedInstance.host = newHost
                println("Transfering host from \"\(oldHost)\" to \"\(newHost)\"")
                
                // Get rid of the old sync msgs & add the new host one
                Game.global.scene?.removeActionForKey("SyncAction")
                Game.global.addSyncActionToScene()
            }
            
        }
        
    }
    func onUnSubscribeRoomDone(event: RoomEvent)
    {
        AppWarpHelper.sharedInstance.disconnectFromAppWarp()
        
    }
    func onLeaveRoomDone(roomEvent: RoomEvent!) {
       
        
    }
    
    func onUpdatePropertyDone(event: LiveRoomInfoEvent!) {
        println("onUpdatePropertyDone")
    }
}
