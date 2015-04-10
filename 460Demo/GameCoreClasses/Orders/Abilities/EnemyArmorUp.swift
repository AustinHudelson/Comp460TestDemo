//
//  EnemyArmorUp.swift
//  460Demo
//
//  Created by Austin Hudelson on 4/10/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(EnemyArmorUp)
class EnemyArmorUp: Order, PType, Transient
{
    let DS_duration = NSTimeInterval(8.0)
    let DS_armorAmount: CGFloat = 0.0
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "EnemyArmorUp"
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(EnemyArmorUp.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        
        let soundAction = SKAction.playSoundFileNamed("bite-small.wav", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        let applyAction: SKAction = SKAction.runBlock(applyBuff)
        let waitAction: SKAction = SKAction.waitForDuration(self.DS_duration)
        let removeAction: SKAction = SKAction.runBlock(removeBuff)
        let applySeq: SKAction = SKAction.sequence([applyAction, waitAction, removeAction])
        self.DS_receiver?.sprite.runAction(applySeq)
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
    func applyBuff()
    {
        self.DS_receiver?.damageMultiplier.addModifier("EnemyArmorUp", value: DS_armorAmount)
        self.DS_receiver?.applyTint("EnemyArmoredUp", red: 0.1, blue: 0.25, green: 0.25)
        //self.DS_receiver?.sprite.runAction(SKAction.scaleBy(0.5, duration: 1.0))
    }
    
    func removeBuff()
    {
        self.DS_receiver?.damageMultiplier.removeModifier("EnemyArmorUp")
        self.DS_receiver?.removeTint("EnemyArmoredUp")
        //self.DS_receiver?.sprite.runAction(SKAction.scaleBy(2.0, duration: 1.0))
        
    }
    
    override func remove() {
        
    }
}