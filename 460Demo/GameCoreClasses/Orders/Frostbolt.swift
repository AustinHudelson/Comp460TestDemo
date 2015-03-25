//
//  Attack.swift
//  460Demo
//
//  Created by Austin on 3/23/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(Frostbolt)
class Frostbolt: Order, PType, Transient
{
    var DS_target: Unit?
    var tID: String = ""
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
        let frostbolt: FrostboltProjectile = FrostboltProjectile(target: DS_target!, caster: DS_receiver!)
    }
    
    override func remove(){
        
    }
}
