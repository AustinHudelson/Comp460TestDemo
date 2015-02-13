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
    let AnimationName = "Character1BaseColorization"
    override init(name: String, health: Int, speed: CGFloat)
    {
        super.init(name: name, health: health, speed: speed)
        self.sprite.xScale = 0.5
        self.sprite.yScale = 0.5
        //self.sprite = SKSpriteNode(imageNamed:AnimationName+"-Stand")
        
        //self.apply(Move(position1: CGPoint(x: 1.0, y: 2.0)))
        //self.move(CGPoint(x: 400, y: 300))
    }
}
