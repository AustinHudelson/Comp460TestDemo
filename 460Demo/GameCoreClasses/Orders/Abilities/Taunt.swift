//
//  Taunt.swift
//  460Demo
//
//  Created by Robert Ko on 3/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit
@objc(Taunt)
class Taunt: Order, PType
{
    var DS_tauntedEnemy: Unit? = nil
    
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Taunt"
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Taunt.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
        
            }
    
    override func apply()
    {
        
        self.taunt()
        println("\(self.DS_receiver!.ID) taunted: \(DS_tauntedEnemy?.ID)")
        
        if DS_tauntedEnemy != nil{
            (DS_tauntedEnemy!.currentOrder as RoamAttack).redirect(self.DS_receiver!)
        }
        
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
        
    }
    
    func taunt()
    {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        let soundAction = SKAction.playSoundFileNamed("zap13.mp3", waitForCompletion: true)
        
        self.DS_receiver?.sprite.runAction(soundAction)
    
        for (id, unit) in Game.global.enemyMap {
            if unit.alive == false {
                continue
            }
            //this line isn't working if the closest one is attacking it doesn't check the next one
            if unit.currentOrder is RoamAttack
            {
                if (unit.currentOrder as RoamAttack).DS_target?.ID == self.DS_receiver!.ID
                {
                    continue
                }
                else
                {
                    var p2 = unit.sprite.position
                    var dist = Game.global.getRelativeDistance(DS_receiver!.sprite.position, p2:p2)
                    if dist < near{
                        nearby = unit
                        near = dist
                    }
                }
            }
           
        }
        
       
        DS_tauntedEnemy = nearby;
        
        
        let applyAction: SKAction = SKAction.runBlock(applyBuff)
        let waitAction: SKAction = SKAction.waitForDuration(NSTimeInterval(1.5))
        let removeAction: SKAction = SKAction.runBlock(removeBuff)
        let applySeq: SKAction = SKAction.sequence([applyAction, waitAction, removeAction])
        self.DS_receiver?.sprite.runAction(applySeq)
     }
    func applyBuff()
    {
        
        self.DS_receiver?.applyTint("Taunted", red: 0.5, blue: 1.0, green: 0.5)
        //self.DS_receiver?.sprite.runAction(SKAction.scaleBy(0.5, duration: 1.0))
    }
    
    func removeBuff()
    {
       
        self.DS_receiver?.removeTint("Taunted")
        //self.DS_receiver?.sprite.runAction(SKAction.scaleBy(2.0, duration: 1.0))
        
    }
    
  
            
            
}