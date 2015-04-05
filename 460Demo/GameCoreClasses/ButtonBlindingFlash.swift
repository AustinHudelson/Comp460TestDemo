//
//  ButtonBlindingFlash.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonBlindingFlash: InstantAbility
{
    
    /*
    * Creates a heal icon at the specified ability use slot
    */
    init(slot: Int){
        super.init(imageNamed: "S_Light02", slot: slot)
    }
    
    override func apply(receiverIn: Unit) {
        
        super.apply(receiverIn)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        var blindingFlash: BlindingFlash = BlindingFlash(receiverIn: receiverIn)
        sendData["Orders"] = []
        sendData["Orders"]!.append(blindingFlash.toJSON())
        NetworkManager.sendMsg(&sendData)
        println("Send blinding flash")
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}