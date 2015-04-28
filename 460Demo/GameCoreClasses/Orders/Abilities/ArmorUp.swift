//
//  ArmorUp.swift
//  460Demo
//
//  Created by Robert Ko on 3/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(ArmorUp)
class ArmorUp: Order, PType, Transient
{
    let DS_duration = NSTimeInterval(5.0)
    let DS_armorAmount: CGFloat = 0.2
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "ArmorUp"
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(ArmorUp.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        
        let soundAction = SKAction.playSoundFileNamed("explode.mp3", waitForCompletion: true)
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
        self.DS_receiver?.damageMultiplier.addModifier("ArmorUp", value: DS_armorAmount)
        self.DS_receiver?.applyTint("ArmoredUp", red: 0.25, blue: 0.25, green: 0.25)
        //self.DS_receiver?.sprite.runAction(SKAction.scaleBy(0.5, duration: 1.0))
    }
    
    func removeBuff()
    {
        self.DS_receiver?.damageMultiplier.removeModifier("ArmorUp")
        self.DS_receiver?.removeTint("ArmoredUp")
        //self.DS_receiver?.sprite.runAction(SKAction.scaleBy(2.0, duration: 1.0))
        
    }
    
    override func remove() {
        
    }
}