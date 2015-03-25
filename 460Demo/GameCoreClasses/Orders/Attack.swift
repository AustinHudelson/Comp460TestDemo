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
        DS_receiver = Game.global.getUnit(self.ID!)
        DS_target = Game.global.getUnit(tID)
    }
    
    override func apply(){
        //apply blue tint to target
        if (DS_receiver!.isLocalPlayer()){
            DS_target!.applyTint("Target", red: 0.5, blue: 2.0, green: 0.7)
        }
        //Dont apply this if we cannot confirm the target and receiver were restored correctly
        if (DS_target != nil && DS_receiver != nil){
            DS_receiver!.attack(DS_target!, complete:{self.DS_receiver!.sendOrder(Idle(receiverIn: self.DS_receiver!))})
        } else {
            self.DS_receiver?.sendOrder(Idle(receiverIn: self.DS_receiver!))
        }
    }
    
    override func remove(){
        //remove blue tint from target
        if (DS_receiver!.isLocalPlayer()){
            DS_target?.removeTint("Target")
        }
        DS_receiver?.clearAttack()
    }
}
