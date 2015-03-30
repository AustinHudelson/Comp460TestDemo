//
//  ButtonSoulExchange.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation


class ButtonSoulExchange: TargetAllyAbility
{
    
    /*
    * Creates a heal icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "S_Magic01", slot: slot)
    }
    
    override func apply(receiverIn: Unit, target: Unit? ) {
        if (target != nil) {
            super.apply(receiverIn, target: target!) /* Dont call super (cooldown) unless there is a valid target*/
            var sendData: Dictionary<String, Array<AnyObject>> = [:]
            var soulExchange: SoulExchange = SoulExchange(receiverIn: receiverIn, target: target!)
            sendData["Orders"] = []
            sendData["Orders"]!.append(soulExchange.toJSON())
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