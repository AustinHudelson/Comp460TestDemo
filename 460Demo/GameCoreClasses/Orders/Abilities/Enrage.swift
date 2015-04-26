//
//  Enrage.swift
//  460Demo
//
//  Created by Robert Ko on 3/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(Enrage)
class Enrage: Order, PType, Transient
{
    var speedInc: CGFloat = 0.0 // The speed to add or multiply to a Unit's movement and attack speed
    var duration: NSTimeInterval = 0.0 // The time, in seconds, of how long this buff lasts
    init(receiverIn: Unit, speedInc: CGFloat, duration: NSTimeInterval)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Enrage"
        self.speedInc = speedInc
        self.duration = duration
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Enrage.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        let soundAction = SKAction.playSoundFileNamed("mnstr10.wav", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        let applyAction: SKAction = SKAction.runBlock(applyBuff)
        let waitAction: SKAction = SKAction.waitForDuration(self.duration)
        let removeAction: SKAction = SKAction.runBlock(removeBuff)
        let applySeq: SKAction = SKAction.sequence([applyAction, waitAction, removeAction])
        self.DS_receiver?.sprite.runAction(applySeq)
    }
    
    func applyBuff()
    {
        self.DS_receiver?.speed.addModifier("Enraged", value: 3.0)
        self.DS_receiver?.attackSpeed.addModifier("Enraged", value: 0.6)
        self.DS_receiver?.applyTint("Enraged", red: 0.0, blue: 1.0, green: 0.5)
    }
    
    func removeBuff()
    {
        self.DS_receiver?.speed.removeModifier("Enraged")
        self.DS_receiver?.attackSpeed.removeModifier("Enraged")
        //SPECIAL CASE. BECAUSE MULTIPLE TINTS IS NOT YET IMPLEMENTED BE SURE TO RESTORE TO GREY COLOR AFTER ENRAGE ENDS IF THE AFFECTED PLAYER IS NOT THE LOCALLY CONTROLLED PLAYER. Because players that are not you are tinted grey atm so you can tell the differance. REMOVE THIS ONCE WE CHANGE HOW THIS WORKS.
        self.DS_receiver?.removeTint("Enraged")
        
    }
    
    override func remove() {
        
    }
    
    
}