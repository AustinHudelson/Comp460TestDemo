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
    var DS_moveToLoc: CGPoint?
    var DS_receiver: Unit?
    var ID = ""
    var posX = CGFloat(0.0)
    var posY = CGFloat(0.0)
    
    init(receiverIn: Unit, moveToLoc: CGPoint)
    {
        self.DS_receiver = receiverIn
        self.DS_moveToLoc = moveToLoc
        self.ID = receiverIn.ID
        self.posX = moveToLoc.x
        self.posY = moveToLoc.y
        super.init()
        self.type = "Move"
    }

    required init(receivedData: Dictionary<String, AnyObject>, unitList: Dictionary<String, Unit>) {
        super.init(receivedData: receivedData, unitList: unitList)
        restoreProperties(Move.self, receivedData: receivedData)
        
        DS_receiver = unitList[ID]!
        DS_moveToLoc = CGPoint(x:posX, y:posY)
    }
    
    override func apply()
    {
        //receiver.sprite.frame.
        DS_receiver!.move(DS_moveToLoc!, complete: {
            self.DS_receiver!.sendOrder(Idle(receiverIn: self.DS_receiver!))
            
        })
    }
    
    override func remove(){
        DS_receiver!.clearMove()
    }
}