//
//  Attack.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Attack: Order
{
    var target:Unit
    /* CHANGE THIS */
    override init(sender: String, receiver: String)
    {
        target = Unit(name: "a", health: 100, speed: CGFloat(100))
        super.init(sender: sender, receiver: receiver)
    }
//    init(tar:Unit)
//    {
//        target = tar;
//    }
//    init(unit:Unit)
//    {
//        target = unit
//    }
//    override var description: String {
//        return "\(target.name)"
//    }
    
}
