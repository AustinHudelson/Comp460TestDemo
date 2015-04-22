//
//  Attack.swift
//  460Demo
//
//  Created by Austin on 3/23/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(Frostbolt)
class Frostbolt: Order, PType
{
    var DS_target: Unit?
    //var ID: String = ""
    var DS_moveState = false
    
    init(receiverIn: Unit, target: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.DS_target = target
        tID = target.ID
        ID = receiverIn.ID
        type = "Frostbolt"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        restoreProperties(Attack.self, receivedData: receivedData)
        DS_receiver = Game.global.getUnit(self.ID!)
        DS_target = Game.global.getUnit(tID)
    }
    
    override func apply(){
        if (DS_target == nil || DS_receiver == nil){
            return
        }
        if (DS_target!.alive == false){
            return
        }
        let soundAction = SKAction.playSoundFileNamed("freeze.wav", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        let frostbolt: FrostboltProjectile = FrostboltProjectile(target: DS_target!, caster: DS_receiver!)
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
    override func remove(){
        
    }
}
