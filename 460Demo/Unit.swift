//
//  Unit.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//


import SpriteKit
class Unit 
{
    var speed = CGFloat(100.0)
    var sprite =  SKSpriteNode(imageNamed:"Spaceship")
    
    
    func apply(order: Order)
    {
        if order is Move
        {
            let moveLoc = (order as Move).position
            println(moveLoc)
            let charPos = sprite.position
            println(charPos)
            let xdif = moveLoc.x-charPos.x
            let ydif = moveLoc.y-charPos.y
            
            let distance = sqrt((xdif*xdif)+(ydif*ydif))
            let duration = distance/speed
            let action = SKAction.moveTo(moveLoc, duration:NSTimeInterval(duration))
            
            sprite.runAction(action)
        }
    }
    
}
