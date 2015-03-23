//
//  ButtonFrostbolt.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/23/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

class ButtonFrostbolt: Ability
{
    /*
    * Creates a enrage icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "E_Gold01", slot: slot)
    }
    
    override func apply(receiverIn: Unit) {
        if (receiverIn.DS_attackTarget != nil) {
            super.apply(receiverIn) /* Dont call super (cooldown) unless there is a valid target*/
            var sendData: Dictionary<String, Array<AnyObject>> = [:]
            var frostbolt: Frostbolt = Frostbolt(receiverIn: receiverIn, target: receiverIn.DS_attackTarget!)
            sendData["Orders"] = []
            sendData["Orders"]!.append(frostbolt.toJSON())
            NetworkManager.sendMsg(&sendData)
        }
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}