//
//  NotificationListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class NotificationListener: NSObject,NotifyListener
{
    func onUpdatePeersReceived(updateEvent:UpdateEvent)
    {
        AppWarpHelper.sharedInstance.recvUpdate(updateEvent.update)
    }
    
    func onUserLeftRoom(roomData: RoomData!, username: String!)
    {
        println("\(username) has left the room!")
        /*
            Transfer host if the host left
        */
        let oldHost = AppWarpHelper.sharedInstance.host
        if username == oldHost {
            WarpClient.getInstance().getLiveRoomInfo(AppWarpHelper.sharedInstance.roomId)
        }
        if username == AppWarpHelper.sharedInstance.playerName
        {
            WarpClient.getInstance().unsubscribeRoom(AppWarpHelper.sharedInstance.roomId)
    
        }
    }
    
    func onUserResumed(userName: String!, withLocation locId: String!, isLobby: Bool)
    {
        
    }
    
    func onUserPaused(userName: String!, withLocation locId: String!, isLobby: Bool)
    {
        
    }
    
    func onUserJoinedRoom(roomData: RoomData!, username: String!)
    {
        println("\(username) joined the room!")
        /*
            Send a request to AppWarp to get live room info when a user joins the room
            If success, RoomListener.onGetLiveRoomInfoDone() will be called and that function
            updates AppWarpHelper.userName_list
        */
        WarpClient.getInstance().getLiveRoomInfo(AppWarpHelper.sharedInstance.roomId)
    }
    
    func onUserChangeRoomProperty(event: RoomData!, username: String!, properties: [NSObject : AnyObject]!, lockedProperties: [NSObject : AnyObject]!) {
        println("user changed the room property!")
    }
    
}
