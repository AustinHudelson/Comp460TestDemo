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
        AppWarpHelper.sharedInstance.receivedEnemyStatus(updateEvent.update)
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
        
    }
    
}
