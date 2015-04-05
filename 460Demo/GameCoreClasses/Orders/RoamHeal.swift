//
//  RoamHeal.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(RoamHeal)
class RoamHeal: Order, PType
{
    var DS_target: Unit? = nil
    //var DS_receiver: Unit?
    var animationGapDistance: CGFloat = 20.0 //Default value is overwritten in init
    var tID: String = "" // target ID
    //var ID: String = ""
    var DS_moveState = false
    
    init(receiverIn: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.DS_target = Game.global.getClosestEnemy(receiverIn.sprite.position, ID: receiverIn.ID) // might be nil when all the other units die
        self.animationGapDistance = 20.0
        if self.DS_target != nil {
            tID = DS_target!.ID
        } // else tID's an empty string
        ID = receiverIn.ID
        type = "RoamHeal"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        restoreProperties(Move.self, receivedData: receivedData)
        
        DS_receiver = Game.global.getUnit(self.ID!)
        DS_target = Game.global.getUnit(tID)
    }
    
    override func apply(){
        println("looking for heal target outside")
        println("Hello\(self.tID)")
        //check if have valid target/dead
        if self.DS_target == nil || !self.DS_target!.alive
        {
            self.DS_target = Game.global.getClosestEnemy(self.DS_receiver!.sprite.position, ID: DS_receiver!.ID) // might be nil when all the players die
            println("looking for heal target")
        }
        
        //if its still nil
        if self.DS_target == nil {
            // no more players to kill so send heal to self order to this unit
            println("healing self")
            self.DS_target = self.DS_receiver!
            self.DS_receiver!.attack(self.DS_target!, complete: {self.apply()})
        }
            
        else {
            //Players left alive. Send attack to unit with complete to recall apply and find a new player to attack.
            println("apply")
            self.DS_receiver!.attack(self.DS_target!, complete: {self.apply()})
        }
    }
    
    override func remove(){
        DS_receiver!.clearAttack()
    }
    func redirect(newTarget: Unit)
    {
        DS_target = newTarget
        self.apply();
    }
}
