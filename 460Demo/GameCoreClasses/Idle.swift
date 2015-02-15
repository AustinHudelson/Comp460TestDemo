//
//  Idle.swift
//  460Demo
//
//  Created by Robert Ko on 2/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

/*
    This Order is what a unit does if it's standing around
    - For now, there's nothing, but maybe later on we can add an idle animation
*/
class Idle: Order, POrder {
    
    var receiver: Unit
    
    override var type: String {
        return "Idle"
    }
    
    init (receiverIn: Unit){
        self.receiver = receiverIn
    }
    
}