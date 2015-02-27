//
//  TurnListener.swift
//  460Demo
//
//  Created by Robert Ko on 2/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

/*
    This listener class is solely used for starting the game just because AppWarp has
    a function called startGame() which gets caught here by this listener. We're not making an turn based game.
*/
class TurnListener: NSObject, TurnBasedRoomListener {
    func onStartGameDone(result: Byte) {
        println("Game starting...")
        AppWarpHelper.sharedInstance.startGame()
    }
}