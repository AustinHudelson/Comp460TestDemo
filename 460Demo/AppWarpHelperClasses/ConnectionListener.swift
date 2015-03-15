//
//  ConnectionListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit




class ConnectionListener: NSObject,ConnectionRequestListener
{
    func onConnectDone(event: ConnectEvent!)
    {
        if event.result == 0 // SUCCESS
        {
            println("onConnectDone SUCCESS")
            /*
                Get a list of joinable rooms
            */
            var roomProperties: Dictionary<String, AnyObject> = [:]
            roomProperties["joinable"] = true
            WarpClient.getInstance().getRoomWithProperties(roomProperties)
        }
        else if event.result == 1  // AUTH_ERROR
        {
            println("onConnectDone AUTH_ERROR")
        }
        else if event.result == 2 // RESOURCE_NOT_FOUND
        {
            println("onConnectDone RESOURCE_NOT_FOUND")
        }
        else if event.result == 3 // RESOURCE_MOVED
        {
            println("onConnectDone RESOURCE_MOVED")
        }
        else if event.result == 4 // BAD_REQUEST
        {
            println("onConnectDone BAD_REQUEST")
        }
        else if event.result == 5 // CONNECTION_ERR
        {
            println("onConnectDone CONNECTION_ERR")
        }
        else if event.result == 6 // UNKNOWN_ERROR
        {
            println("onConnectDone UNKNOWN_ERROR")
        }
        else if event.result == 7 // RESULT_SIZE_ERROR
        {
            println("onConnectDone RESULT_SIZE_ERROR")
        }
        else if event.result == 8 // SUCCESS_RECOVERED
        {
            println("onConnectDone SUCCESS_RECOVERED")
        }
        else if event.result == 9 // CONNECTION_ERROR_RECOVERABLE
        {
            println("onConnectDone CONNECTION_ERROR_RECOVERABLE")
        }
        else
        {
            println("onConnectDone Unknown Error")
        }
    }
    
    func onDisconnectDone(event: ConnectEvent!) {
        println("Disconnect done")
    }
}
