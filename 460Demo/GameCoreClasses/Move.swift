//
//  File.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Move : Order, PType
{
    var moveToLoc: CGPoint
    var receiver: Unit
    
    override var type: String {
        return "Move"
    }
    
    init(receiverIn: Unit, moveToLoc: CGPoint)
    {
        self.receiver = receiverIn
        self.moveToLoc = moveToLoc
        super.init()
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