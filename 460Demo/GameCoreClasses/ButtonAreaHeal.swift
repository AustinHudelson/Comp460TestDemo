//
//  ButtonHeal.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonAreaHeal: InstantAbility
{
    
    /*
    * Creates a heal icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "S_Holy05", slot: slot)
    }
    
    override func apply(receiverIn: Unit) {
        super.apply(receiverIn)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        var heal: AreaHeal = AreaHeal(receiverIn: receiverIn)
        sendData["Orders"] = []
        sendData["Orders"]!.append(heal.toJSON())
        NetworkManager.sendMsg(&sendData)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}