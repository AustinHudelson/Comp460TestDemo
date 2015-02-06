//
//  Unit.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//


import SpriteKit
class Unit: Printable
{
    var name: String
    var health: Int
    var speed: CGFloat
    var sprite: SKSpriteNode
    var description: String {
        return "Unit(name: \(name), health: \(health), speed: \(speed), sprite:\(sprite))"
    }
    
    init(name: String, health: Int, speed: CGFloat) {
        self.name = name
        self.health = health
        self.speed = speed
        self.sprite = SKSpriteNode(imageNamed:"Spaceship")
    }
    
    
    func apply(order: Order)
    {
        if order is Move
        {
            let moveLoc = (order as Move).position
            move(moveLoc)
           
        }
        else if order is Attack
        {
            var target = (order as Attack).target
            
            move(target.sprite.position)
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
    func move(destination:CGPoint )
    {
        let charPos = sprite.position
        println(charPos)
        let xdif = destination.x-charPos.x
        let ydif = destination.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/speed
        let action = SKAction.moveTo(destination, duration:NSTimeInterval(duration))
        
        sprite.runAction(action)
    }
    
}
