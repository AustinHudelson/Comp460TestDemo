//
//  ButtonBlink.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonBlink: InstantAbility
{
    
    /*
    * Creates a heal icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "S_Buff10", slot: slot)
        self.cooldown = 8.0
    }
    
    override func apply(receiverIn: Unit) {
        super.apply(receiverIn)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        var ability: Order = Blink(receiverIn: receiverIn)
        sendData["Orders"] = []
        sendData["Orders"]!.append(ability.toJSON())
        NetworkManager.sendMsg(&sendData)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}