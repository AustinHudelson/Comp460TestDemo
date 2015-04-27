//
//  BlindingFlash.swift
//  460Demo
//
//  Created by Olyver on 3/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(BlindingFlash)
class BlindingFlash: Order, PType
{
    let DS_radius: CGFloat = 400
    let DS_bump: CGFloat = 300
    let DS_stunDuration: NSTimeInterval = 2.0
    let DS_damage: CGFloat = 10.0
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "BlindingFlash"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(BlindingFlash.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
       if DS_receiver == nil {
            return
        }
        self.blindingFlash()
      
       
    }
    
    func blindingFlash()
    {
        let soundAction = SKAction.playSoundFileNamed("warp.mp3", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        for (id, unit) in Game.global.enemyMap{
            if Game.global.getDistance(DS_receiver!.sprite.position, p2: unit.sprite.position) < DS_radius
            {
                var destination = CGPoint(x:0,y:0)
                var unitX = unit.sprite.position.x
                var unitY = unit.sprite.position.y
                if DS_receiver!.sprite.position.x < unit.sprite.position.x
                {
                    if Game.global.scene!.frame.contains(CGPoint(x:unitX + DS_bump, y:unitY))
                    {
                        destination = CGPoint(x:unitX + DS_bump, y:unitY)
                    }
                    
                    else
                    {
                        destination = CGPoint(x:Game.global.scene!.frame.maxX, y:unitY)
                    }
                }
                else
                {
                    if Game.global.scene!.frame.contains(CGPoint(x:unitX - DS_bump, y:unitY))
                    {
                        destination = CGPoint(x:unitX - DS_bump, y:unitY)
                    }
                        
                    else
                    {
                        destination = CGPoint(x:Game.global.scene!.frame.minX, y:unitY)
                    }
                }
                
                let moveAction: SKAction = SKAction.moveTo(destination, duration: NSTimeInterval(0.5))
                unit.sprite.runAction(moveAction, withKey: "BlindingFlash")
                unit.takeDamage(self.DS_damage)
                let applyIdle: SKAction = SKAction.runBlock({
                    unit.sendOrder(Idle(receiverIn: unit))
                })
                let applyOldOrder: SKAction = SKAction.runBlock({
                    if (unit.alive == true){
                        if (unit is EnemyPriest) {
                            unit.sendOrder(RoamHeal(receiverIn: unit))
                        } else {
                            unit.sendOrder(RoamAttack(receiverIn: unit))
                        }
                    }
                })
                let waitStunDuration: SKAction = SKAction.waitForDuration(2.0)
                let stunSequence: SKAction = SKAction.sequence([applyIdle, waitStunDuration, applyOldOrder])
                unit.sprite.runAction(stunSequence)
            }
            

        }
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
}