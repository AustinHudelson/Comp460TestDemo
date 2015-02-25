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
    var tID: String = ""
    //var ID: String = ""
    
    init(receiverIn: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.DS_target = GameScene.global.getClosestPlayer(receiverIn.sprite.position)
        self.animationGapDistance = 20.0
        tID = DS_target!.ID
        ID = receiverIn.ID
        type = "RoamAttack"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>, unitList: Dictionary<String, Unit>) {
        super.init(receivedData: receivedData, unitList: unitList)
        restoreProperties(Move.self, receivedData: receivedData)
        
        DS_receiver = unitList[self.ID!]!
        DS_target = unitList[tID]!
    }
    
    override func apply(){
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
            
            
            DS_receiver!.move(movePos, complete:{
                self.DS_receiver!.clearMove()
                var frontConnection = CGPoint(x: self.DS_receiver!.sprite.position.x+self.animationGapDistance,y: self.DS_receiver!.sprite.position.y)
                var backConnection=CGPoint(x: self.DS_receiver!.sprite.position.x-self.animationGapDistance,y: self.DS_receiver!.sprite.position.y)
                
                if  self.DS_target!.sprite.frame.contains(frontConnection)||self.DS_target!.sprite.frame.contains(backConnection)
                {
                    self.attackCycle()
                    self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_attackAnim!, withKey: "AttackAnim")
                    let delay = SKAction.waitForDuration(1.0)
                    self.DS_receiver!.sprite.runAction(delay, completion: self.apply)
                }
                else
                {
                    self.apply()
                }
            })
        }
        
    }
    
    func attackCycle(){
        DS_target!.takeDamage(1)
    }
    
    override func update(){
        //Check things like, the target is still in range... etc.
    }
    
    override func remove(){
        DS_receiver!.clearMove()
    }
    
    
    
}
