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
    
    override func remove(){
        DS_receiver!.clearAttack()
    }
}
