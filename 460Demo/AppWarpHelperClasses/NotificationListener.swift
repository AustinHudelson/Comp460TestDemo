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
        println("onUpdatePeersReceived")
        
        AppWarpHelper.sharedInstance.recvUpdate(updateEvent.update)
    }
    func onUserLeftRoom(roomData: RoomData!, username: String!)
    {
        
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
            Send a request to AppWarp to get live room info.
            If success, RoomListener.onGetLiveRoomInfoDone() will be called and that function
            updates AppWarpHelper.userName_list
        */
        WarpClient.getInstance().getLiveRoomInfo(AppWarpHelper.sharedInstance.roomId)
    }
    
}
