//
//  SoulExchange.swift
//  460Demo
//
//  Created by Olyver on 3/29/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(SoulExchange)
class SoulExchange: Order, PType, Transient
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
        type = "SoulExchange"
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
        var yourHealth: CGFloat = DS_receiver!.health/DS_receiver!.maxhealth.get()
        var otherHealth: CGFloat = DS_target!.health/DS_target!.maxhealth.get()
        println("your health% \(yourHealth)\n")
        println("their health% \(otherHealth)\n")
        DS_receiver!.health = yourHealth * DS_receiver!.maxhealth.get()
        DS_target!.health = otherHealth * DS_target!.maxhealth.get()
        DS_receiver!.updateHealthBar()
        DS_target!.updateHealthBar()
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
    
    override func remove(){
        
    }
}