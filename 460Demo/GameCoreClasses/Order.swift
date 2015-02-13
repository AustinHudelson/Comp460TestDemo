//
//  Order.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

class Order: SerializableJSON
{
    /*
        sender is the unit that's the host.
        receiver is the target
        Eg.
            Move(unit_A, nil) means unit_A is moving to a position
            Attack(unit_A, unit_B) means unit_A is attacking unit_B
    */
    var sender: Unit
    var receiver: Unit
    
    init(sender: Unit, receiver: Unit) {
        self.sender = sender
        self.receiver = receiver
    }
}
