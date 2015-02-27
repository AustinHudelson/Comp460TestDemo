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
        
        /*
            if gameScene is not initialized yet, that means this msg received is host's start game msg,
            so start the game instead of calling the recvUpdate() function, which should only be called
            when the game has actually started
        */
        if AppWarpHelper.sharedInstance.gameScene == nil {
            var recvData = updateEvent.update
            var recvMsg = NSString(data: recvData, encoding: NSUTF8StringEncoding) as String
            if recvMsg == "Start Game!" {
                AppWarpHelper.sharedInstance.startGame()
            }
        } else {
            AppWarpHelper.sharedInstance.recvUpdate(updateEvent.update)
        }
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
