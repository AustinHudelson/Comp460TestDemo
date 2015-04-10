//
//  File.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonEnrage: InstantAbility
{
    
    /*
    * Creates a enrage icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "S_Buff04", slot: slot)
    }
    
    override func apply(receiverIn: Unit) {
        super.apply(receiverIn)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        var enrage: Enrage = Enrage(receiverIn: receiverIn, speedInc: 7.0, duration: 2.0)
        sendData["Orders"] = []
        sendData["Orders"]!.append(enrage.toJSON())
        NetworkManager.sendMsg(&sendData)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}