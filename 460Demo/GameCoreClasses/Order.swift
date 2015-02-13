//
//  Order.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

class Order: SerializableJSON
{
    var sender: Unit
    var receiver: Unit
    
    init(sender: Unit, receiver: Unit) {
        self.sender = sender
        self.receiver = receiver
    }
//    var description: String {
//        return "MyType: Order"
//    }
}
