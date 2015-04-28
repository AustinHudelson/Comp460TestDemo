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
            Transfer host if whoever is leaving was the host
        */
        let oldHost = AppWarpHelper.sharedInstance.host
        if username == oldHost {
            WarpClient.getInstance().getLiveRoomInfo(AppWarpHelper.sharedInstance.roomId)
        }
        
        /*
            If i'm the leaver, I should unsubscribe from room
        */
        if username == AppWarpHelper.sharedInstance.playerName
        {
            // We also need to unsubscribe ourselves from the room after we leave the room
            WarpClient.getInstance().unsubscribeRoom(AppWarpHelper.sharedInstance.roomId)
    
        }
        
        /*
            This code structure is kind of bad, but it's just a quick fix now for users pressing Exit in lobby.
            Basically tell everyone who's not the leaver to request live room info so they can update their lobby
        */
        if !(Game.global.sceneActive) == false && (username != AppWarpHelper.sharedInstance.playerName) {
            WarpClient.getInstance().getLiveRoomInfo(AppWarpHelper.sharedInstance.roomId)
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
