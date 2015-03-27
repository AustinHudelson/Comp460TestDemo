//
//  Blink.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(Blink)
class Blink: Order, PType, Transient
{
    var destX: CGFloat = 0.0
    var destY: CGFloat = 0.0
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Blink"
        
        let minX: CGFloat = Game.global.scene!.frame.minX+50.0
        let maxX: CGFloat = Game.global.scene!.frame.maxX-50.0
        let minY: CGFloat = Game.global.scene!.frame.minY+50.0
        let maxY: CGFloat = Game.global.scene!.frame.maxY-50.0
        destX = CGFloat.random(min: minX, max: maxX)
        destY = CGFloat.random(min: minY, max: maxY)
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Enrage.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        //let soundAction = SKAction.playSoundFileNamed("ogre3.wav", waitForCompletion: true)
        //self.DS_receiver?.sprite.runAction(soundAction)
        //let applyAction: SKAction = SKAction.runBlock(applyBuff)
        //let waitAction: SKAction = SKAction.waitForDuration(0.5)
        //let removeAction: SKAction = SKAction.runBlock(removeBuff)
        //let applySeq: SKAction = SKAction.sequence([applyAction, waitAction, removeAction])
        //self.DS_receiver?.sprite.runAction(applySeq)
        //let destination = CGPoint(x:destX, y:destY)
        //self.DS_receiver?.sprite.position = destination
    }
    
    override func remove() {
        
    }
    
    
}