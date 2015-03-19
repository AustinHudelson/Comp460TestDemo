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
    let DS_healAmount: Int = 20
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
            self.healOverTime(DS_healAmount, target:unit)
        }
        println("\(self.DS_receiver!.ID) health after Heal: \(self.DS_receiver!.health)")
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
    func healOverTime(heal: Int, target:Unit){
        let soundAction = SKAction.playSoundFileNamed("spell.wav", waitForCompletion: true)
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