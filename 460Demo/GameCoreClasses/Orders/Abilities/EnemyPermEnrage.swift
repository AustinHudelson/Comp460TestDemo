//
//  EnemyPermEnrage.swift
//  460Demo
//
//  Created by Austin Hudelson on 4/10/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(EnemyPermEnrage)
class EnemyPermEnrage: Order, PType, Transient
{

    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "EnemyPermEnrage"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Enrage.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        let soundAction = SKAction.playSoundFileNamed("ogre3.wav", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        let applyAction: SKAction = SKAction.runBlock(applyBuff)
        self.DS_receiver?.sprite.runAction(applyAction)
    }
    
    func applyBuff()
    {
        self.DS_receiver?.speed.addModifier("PermEnrage1", value: 2.0)
        self.DS_receiver?.attackSpeed.addModifier("PermEnrage1", value: 0.4)
        self.DS_receiver?.applyTint("PermEnrage1", red: 1.0, blue: 0.5, green: 0.5)
    }
    
    override func remove() {
        
    }
    
    
}