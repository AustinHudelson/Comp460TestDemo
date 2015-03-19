//
//  Shrink.swift
//  460Demo
//
//  Created by Robert Ko on 3/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(Shrink)
class Shrink: Order, PType
{
    var healAmount: Int = 0
    let DS_duration = NSTimeInterval(8.0)
    var DS_target: Unit?
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Shrink"
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Shrink.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        if DS_receiver == nil {
            return
        }
        
        DS_target = Game.global.getClosestEnemy(DS_receiver!.sprite.position)
        
        if DS_target == nil {
            return
        }
        let soundAction = SKAction.playSoundFileNamed("bite-small.wav", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        let applyAction: SKAction = SKAction.runBlock(applyBuff)
        let waitAction: SKAction = SKAction.waitForDuration(self.DS_duration)
        let removeAction: SKAction = SKAction.runBlock(removeBuff)
        let applySeq: SKAction = SKAction.sequence([applyAction, waitAction, removeAction])
        self.DS_target?.sprite.runAction(applySeq)
    }
    
    func applyBuff()
    {
        self.DS_target?.speed.addModifier("Shrink", value:0.25)
        self.DS_target?.sprite.runAction(SKAction.scaleBy(0.5, duration: 1.0))
    }
    
    func removeBuff()
    {
        self.DS_target?.speed.removeModifier("Shrink")
        self.DS_target?.sprite.runAction(SKAction.scaleBy(2.0, duration: 1.0))
        
    }
    
    override func remove() {
        
    }
}