//
//  Warrior.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
class Warrior: Unit
{
    override init()
    {
        super.init()
        speed = CGFloat(100.0);
        sprite = SKSpriteNode(imageNamed:"Mage")
    }
}
