//
//  Attack.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Attack: Order, POrder
{
    var target: Unit
    var receiver: Unit
    
    override var type: String {
        return "Attack"
    }
    
    init(receiverIn: Unit, target: Unit){
        receiver = receiverIn
        self.target = target
        super.init()
    }
    
    override func apply(){
        if self.receiver.currentOrder is Attack
        {
            receiver.move(target.sprite.position, complete:{
                self.receiver.clearMove()
                
                self.attackCycle()
                
                self.receiver.sprite.runAction(self.receiver.attackAnim, withKey: "AttackAnim")
                let delay = SKAction.waitForDuration(1.0)
                self.receiver.sprite.runAction(delay, completion: self.apply)
                
            })
        }
        
    }
    
    func attackCycle(){
        target.takeDamage(1)
    }
    
    override func update(){
        //Check things like, the target is still in range... etc.
    }
    
    override func remove(){
        receiver.clearMove()
    }
    
    
    
}
