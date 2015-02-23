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
    //var DS_receiver: Unit?
    //var ID = ""
    var posX = CGFloat(0.0)
    var posY = CGFloat(0.0)
    
    init(receiverIn: Unit, moveToLoc: CGPoint)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.DS_moveToLoc = moveToLoc
        self.ID = receiverIn.ID
        self.posX = moveToLoc.x
        self.posY = moveToLoc.y
        self.type = "Move"
    }

    required init(receivedData: Dictionary<String, AnyObject>, unitList: Dictionary<String, Unit>) {
        super.init(receivedData: receivedData, unitList: unitList)
        self.restoreProperties(Move.self, receivedData: receivedData)
        
        if unitList[ID!] == nil {
            println("Issue setting receiver!")
        }
        self.DS_receiver = unitList[ID!]!
        self.DS_moveToLoc = CGPoint(x:posX, y:posY)
    }
    
    override func apply()
    {
        //receiver.sprite.frame.
        self.DS_receiver!.move(self.DS_moveToLoc!, complete: {
            self.DS_receiver!.sendOrder(Idle(receiverIn: self.DS_receiver!))
        })
    }
    
    override func remove(){
        self.DS_receiver!.clearMove()
    }
}