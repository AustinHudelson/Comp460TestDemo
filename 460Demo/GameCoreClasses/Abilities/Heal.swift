//
//  Heal.swift
//  460Demo
//
//  Created by Robert Ko on 3/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

@objc(Heal)
class Heal: Order, PType
{
    var healAmount: Int = 0
    init(receiverIn: Unit, healAmount: Int)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Heal"
        self.healAmount = healAmount
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Heal.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        self.DS_receiver?.takeDamage(-self.healAmount)
        println("\(self.DS_receiver!.ID) health after Heal: \(self.DS_receiver!.health)")
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
    }
}