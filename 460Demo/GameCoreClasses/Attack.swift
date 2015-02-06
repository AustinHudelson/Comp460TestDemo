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
    init(tar:Unit)
    {
        target = tar;
    }
    init(unit:Unit)
    {
        target = unit
    }
    override var description: String {
        return "\(target.name)"
    }
    
}
