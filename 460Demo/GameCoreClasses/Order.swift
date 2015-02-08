//
//  Order.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

class Order: SerializableJSON
{
    var sender: String
    var receiver: String
    
    init(sender: String, receiver: String) {
        self.sender = sender
        self.receiver = receiver
    }
//    var description: String {
//        return "MyType: Order"
//    }
}
