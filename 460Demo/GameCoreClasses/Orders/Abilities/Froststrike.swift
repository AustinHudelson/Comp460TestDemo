//
//  Flamestrike.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//


import SpriteKit

@objc(Froststrike)
class Froststrike: Order, PType
{
    var DS_moveState = false
    
    init(receiverIn: Unit){
        super.init()
        self.DS_receiver = receiverIn
        ID = receiverIn.ID
        type = "Froststrike"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        restoreProperties(Attack.self, receivedData: receivedData)
        DS_receiver = Game.global.getUnit(self.ID!)
    }
    
    override func apply(){
        let soundAction = SKAction.playSoundFileNamed("fireball.wav", waitForCompletion: true)
        self.DS_receiver?.sprite.runAction(soundAction)
        let flamestrike: Projectile = FlamestrikeProjectile(caster: DS_receiver!)
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
    override func remove(){
        
    }
}