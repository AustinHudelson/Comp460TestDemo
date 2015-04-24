//
//  AreaHeal.swift
//  460Demo
//
//  Created by Robert Ko on 3/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(AreaHeal)
class AreaHeal: Order, PType
{
    let DS_healAmount: Int = 30
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "AreaHeal"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(AreaHeal.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        for (id, unit) in Game.global.playerMap{
            
            //Actually call the heal over time.
            self.healOverTimeStart(DS_healAmount, unit:unit)
        }
        println("\(self.DS_receiver!.ID) health after Heal: \(self.DS_receiver!.health)")
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
    func healOverTimeStart(heal: Int, unit: Unit){
        let emitterPath: String = NSBundle.mainBundle().pathForResource("AreaHealParticle", ofType: "sks")!
        let emitterNode: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as SKEmitterNode
        //Setup heal particle emitter
        emitterNode.name = "AreaHealing"
        emitterNode.zPosition = unit.sprite.zPosition+2
        emitterNode.targetNode = unit.sprite
        
        let stopEmittingDelayAction: SKAction = SKAction.waitForDuration(NSTimeInterval(2.0))
        let stopEmittingAction: SKAction = SKAction.runBlock({
            emitterNode.particleBirthRate = 0.0
        })
        let removeNodeDelayAction: SKAction = SKAction.waitForDuration(NSTimeInterval(3.0))
        let removeNodeBlock: SKAction = SKAction.runBlock({
            emitterNode.removeFromParent()
        })
        //Start the emitter node, wait half, heal, wait half again, remove the emitter node
        unit.sprite.addChild(emitterNode)   //Start the emitter node
        //Action sequence: Wait. Stop Emitting. Wait. Destroy Node.
        unit.sprite.runAction(SKAction.sequence([stopEmittingDelayAction, stopEmittingAction, removeNodeDelayAction, removeNodeBlock]))
        
        self.healOverTime(heal, target:unit)
    }
    
    func healOverTime(heal: Int, target:Unit){
        
        
        
        self.DS_receiver?.sprite.runAction(soundAction)
        let wait = NSTimeInterval(0.0625)
        if (heal <= 0) {
            return
        } else {
            //Start a loop on the sprite. Wait for .0625 seconds, heal it by 1, then recall this function.
            let waitAction: SKAction = SKAction.waitForDuration(wait)
            let healBlock: SKAction = SKAction.runBlock({
                if target.alive == true {
                    target.takeDamage(-2)
                    self.healOverTime(heal-2, target:target)
                }
            })
            self.DS_receiver?.sprite.runAction(SKAction.sequence([waitAction, healBlock]))
        }
    }
}