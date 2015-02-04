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
    var name = "hi"
    var health = 100;
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
        else if order is Attack
        {
            var target = (order as Attack).target
            if(sprite.intersectsNode(target.sprite))
            {
                target.takeDamage(1)
            }
        }
    }
    
    func takeDamage(damage:Int)
    {
        health-=damage
        println("\(name), \(health)")
    }
    
    
}
