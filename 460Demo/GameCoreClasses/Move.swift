//
//  File.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(Move)
class Move : Order, PType
{
    var moveToLoc: CGPoint
    var receiver: Unit
    
    init(receiverIn: Unit, moveToLoc: CGPoint)
    {
        self.receiver = receiverIn
        self.moveToLoc = moveToLoc
        super.init()
        self.type = "Move"
    }
    
    override func apply()
    {
        //receiver.sprite.frame.
        receiver.move(moveToLoc, complete: {
            self.receiver.sendOrder(Idle(receiverIn: self.receiver))
            
        })
    }
    
    override func remove(){
        receiver.clearMove()
    }
}