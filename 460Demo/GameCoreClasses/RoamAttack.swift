//
//  Attack.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(RoamAttack)
class RoamAttack: Order, PType
{
    var DS_target: Unit?
    //var DS_receiver: Unit?
    var animationGapDistance: CGFloat = 20.0 //Default value is overwritten in init
    var tID: String = "" // target ID
    //var ID: String = ""
    var DS_moveState = false
    
    init(receiverIn: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.DS_target = Game.global.getClosestPlayer(receiverIn.sprite.position) // might be nil when all the players die
        self.animationGapDistance = 20.0
        if self.DS_target != nil {
            tID = DS_target!.ID
        } // else tID's an empty string
        ID = receiverIn.ID
        type = "RoamAttack"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        restoreProperties(Move.self, receivedData: receivedData)
        
        DS_receiver = Game.global.getUnit(self.ID!)
        DS_target = Game.global.getUnit(tID)
    }
    
    override func apply(){
        self.DS_target = Game.global.getClosestPlayer(self.DS_receiver!.sprite.position) // might be nil when all the players die
        if self.DS_target == nil {
            // no more players to kill so send idle order to this unit
            let idle: Idle = Idle(receiverIn: self.DS_receiver!)
            self.DS_receiver?.sendOrder(idle)
        } else {
            //Players left alive. Send attack to unit with complete to recall apply and find a new player to attack.
            self.DS_receiver!.attack(self.DS_target!, complete: {self.apply()})
        }
    }
    
    func attackCycle(){
        let tolerence = DS_receiver!.attackRange
        if self.DS_receiver!.currentOrder is RoamAttack
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
            
            if Game.global.getDistance(DS_receiver!.sprite.position, p2: movePos) > tolerence {
                DS_moveState = true
                DS_receiver!.move(movePos, complete:{
                    self.DS_moveState = false
                    self.DS_receiver!.clearMove()
                    self.attackCycle()
                    //
                    //                    var frontConnection = CGPoint(x: self.DS_receiver!.sprite.position.x+self.animationGapDistance,y: self.DS_receiver!.sprite.position.y)
                    //                    var backConnection=CGPoint(x: self.DS_receiver!.sprite.position.x-self.animationGapDistance,y: self.DS_receiver!.sprite.position.y)
                    //
                    //                    if  self.DS_target!.sprite.frame.contains(frontConnection)||self.DS_target!.sprite.frame.contains(backConnection) {
                    //
                    //                    }
                    //                    else
                    //                    {
                    //                        self.apply()
                    //                    }
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
        //if DS_moveState == true {
        //    DS_receiver!.clearMove()
        //    DS_moveState = false
        //    attackCycle()
        //}
        
    }
    
    override func remove(){
        DS_receiver!.clearAttack()
    }
    
    
    
}
