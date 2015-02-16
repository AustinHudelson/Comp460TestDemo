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
    var animationGapDistance: CGFloat
    
    override var type: String {
        return "Attack"
    }
    
    init(receiverIn: Unit, target: Unit){
        receiver = receiverIn
        self.target = target
        self.animationGapDistance = 10
        super.init()
    }
    
    override func apply(){
        if self.receiver.currentOrder is Attack
        {
            var movePos: CGPoint
            if(receiver.sprite.position.x < target.sprite.position.x)
            {
                movePos = CGPoint(x: target.sprite.frame.minX-animationGapDistance,y : target.sprite.frame.midY)
            }
            else
            {
                movePos = CGPoint(x: target.sprite.frame.maxX-1+animationGapDistance,y : target.sprite.frame.midY)
            }
            
            
            receiver.move(movePos, complete:{
                self.receiver.clearMove()
                var frontConnection = CGPoint(x: self.receiver.sprite.position.x+self.animationGapDistance,y: self.receiver.sprite.position.y)
                var backConnection=CGPoint(x: self.receiver.sprite.position.x-self.animationGapDistance,y: self.receiver.sprite.position.y)
                
                if  self.target.sprite.frame.contains(frontConnection)||self.target.sprite.frame.contains(backConnection)
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
