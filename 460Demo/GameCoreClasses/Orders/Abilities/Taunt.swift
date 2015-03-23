//
//  Taunt.swift
//  460Demo
//
//  Created by Robert Ko on 3/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

@objc(Taunt)
class Taunt: Order, PType
{
    init(receiverIn: Unit, speedInc: CGFloat, duration: NSTimeInterval)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Taunt"
        
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Enrage.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply() {
        
    }
    
    override func remove() {
        
    }
}