//
//  Unit.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
class Unit: SerializableJSON
{
    var name: String
    var health: Int
    var speed: CGFloat
    var sprite: SKSpriteNode
    
    init(name: String, health: Int, speed: CGFloat) {
        self.name = name
        self.health = health
        self.speed = speed
        
        //
        //Define Animations here
        //
        
        let walkAtlas = SKTextureAtlas(named: "Walk")
        
        let walkAnim = SKAction.animateWithTextures([
            walkAtlas.textureNamed("Character1BaseColorization-Walk20"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk21"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk22"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk23"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk24"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk25"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk26"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk27"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk28"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk29"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk210"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk211"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk212"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk213"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk214"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk215"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk216"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk217"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk218"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk219"),
            walkAtlas.textureNamed("Character1BaseColorization-Walk220")
        ], timePerFrame: 0.05)
        
        var walking = SKAction.repeatActionForever(walkAnim)
        
        self.sprite = SKSpriteNode(imageNamed:"Character1BaseColorization-Stand")
        var mir = SKAction.scaleXTo(-.25, duration: 0.0)
        
        self.sprite.runAction(walking)
        self.sprite.runAction(mir)
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
