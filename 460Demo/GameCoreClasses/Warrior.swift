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
    override init(name: String, health: Int, speed: CGFloat)
    {
        super.init(name: name, health: health, speed: speed)
        self.sprite = SKSpriteNode(imageNamed:"Mage")
    }
}
