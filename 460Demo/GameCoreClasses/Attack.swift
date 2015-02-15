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
            var movePos: CGPoint
            if(receiver.sprite.position.x < target.sprite.position.x)
            {
                movePos = CGPoint(x: target.sprite.frame.minX,y : target.sprite.frame.midY)
            }
            else
            {
                movePos = CGPoint(x: target.sprite.frame.maxX,y : target.sprite.frame.midY)
            }
            
            
            receiver.move(movePos, complete:{
                self.receiver.clearMove()
                
                if  self.target.sprite.frame.contains(self.receiver.sprite.position)
                {
                    self.attackCycle()
                    self.receiver.sprite.runAction(self.receiver.attackAnim, withKey: "AttackAnim")
                    let delay = SKAction.waitForDuration(1.0)
                    self.receiver.sprite.runAction(delay, completion: self.apply)
                }
                else
                {
                    self.apply()
                }
                
                
                
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
