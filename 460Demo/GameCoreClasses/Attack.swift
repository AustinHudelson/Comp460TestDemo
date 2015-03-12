//
//  Attack.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(Attack)
class Attack: Order, PType
{
    var DS_target: Unit?
    //var DS_receiver: Unit?
    var animationGapDistance: CGFloat = 20.0
    var tID: String = ""
    //var ID: String = ""
    var DS_moveState = false
    
    init(receiverIn: Unit, target: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.DS_target = target
        self.animationGapDistance = 20.0
        tID = target.ID
        ID = receiverIn.ID
        type = "Attack"
    }

    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        restoreProperties(Attack.self, receivedData: receivedData)
        println(tID)
        DS_receiver = Game.global.getUnit(self.ID!)
        DS_target = Game.global.getUnit(tID)
    }
    
    override func apply(){
        if (DS_receiver!.isLocalPlayer()){
            DS_target!.applyTint(SKColor.blueColor(), factor: 0.5, blendDuration: 0.0)
        }
        self.attackCycle()
    }
    
    func attackCycle(){
        let tolerence = CGFloat(20.0)
        if self.DS_receiver!.currentOrder is Attack
        {
            var movePos: CGPoint
            if(DS_receiver!.sprite.position.x < DS_target!.sprite.position.x)
            {
                movePos = CGPoint(x: DS_target!.sprite.frame.minX-animationGapDistance,y : DS_target!.sprite.frame.midY)
            }
            else
            {
                movePos = CGPoint(x: DS_target!.sprite.frame.maxX-1+animationGapDistance,y : DS_target!.sprite.frame.midY)
            }
            
            self.DS_moveState = true
            if Game.global.getDistance(DS_receiver!.sprite.position, p2: movePos) > tolerence {
                DS_receiver!.move(movePos, complete:{
                    self.DS_moveState = false
                    self.DS_receiver!.clearMove()
                    self.attackCycle()
                })
            } else {
                if DS_receiver!.sprite.position.x < DS_target!.sprite.position.x {
                    DS_receiver!.faceRight()
                } else {
                    DS_receiver!.faceLeft()
                }
                self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_attackAnim!, withKey: "AttackAnim")
                let delay = SKAction.waitForDuration(1.0)
                self.DS_receiver!.sprite.runAction(delay, completion: self.attackCycle)
                DS_target!.takeDamage(3)
            }
        }
    }
    
    override func update(){
        if DS_moveState == true {
            DS_receiver!.clearMove()
            DS_moveState = false
            attackCycle()
        }
    }
    
    override func remove(){
        if (DS_receiver!.isLocalPlayer()){
            DS_target!.applyTint(SKColor.whiteColor(), factor: 0.5, blendDuration: 0.0)
        }
        DS_receiver!.clearMove()
    }
    
    
    
}
