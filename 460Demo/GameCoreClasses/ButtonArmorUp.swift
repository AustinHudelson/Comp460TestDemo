//
//  ButtonArmourUp.swift
//  460Demo
//
//  Created by Olyver on 3/24/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
class ButtonArmorUp: Ability
{
    /*
    * Creates a enrage icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "A_Armor04", slot: slot)
    }
    
    override func apply(receiverIn: Unit) {
        super.apply(receiverIn)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        var armorUp: ArmorUp = ArmorUp(receiverIn: receiverIn)
        sendData["Orders"] = []
        sendData["Orders"]!.append(armorUp.toJSON())
        NetworkManager.sendMsg(&sendData)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}