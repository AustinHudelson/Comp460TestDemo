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
        super.apply(receiverIn)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        var taunt: Taunt = Taunt(receiverIn: receiverIn)
        sendData["Orders"] = []
        sendData["Orders"]!.append(taunt.toJSON())
        NetworkManager.sendMsg(&sendData)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}