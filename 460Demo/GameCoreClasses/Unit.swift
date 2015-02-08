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
    var walkAnim: SKAction
    var attackAnim: SKAction
    var standAnim: SKAction
    
    init(name: String, health: Int, speed: CGFloat) {
        self.name = name
        self.health = health
        self.speed = speed
        
        //
        //Define Animations here
        //
        
        let walkAtlas = SKTextureAtlas(named: "Walk")
        let attackAtlas = SKTextureAtlas(named: "Attack")
        let unitName = "Character1BaseColorization"
        let walkAnimName = "-Walk2"
        let attackAnimName = "-Attack"
        let standAnimName = "-Attack"
        
        var walkTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(unitName+walkAnimName+"0"),
            walkAtlas.textureNamed(unitName+walkAnimName+"1"),
            walkAtlas.textureNamed(unitName+walkAnimName+"2"),
            walkAtlas.textureNamed(unitName+walkAnimName+"3"),
            walkAtlas.textureNamed(unitName+walkAnimName+"4"),
            walkAtlas.textureNamed(unitName+walkAnimName+"5"),
            walkAtlas.textureNamed(unitName+walkAnimName+"6"),
            walkAtlas.textureNamed(unitName+walkAnimName+"7"),
            walkAtlas.textureNamed(unitName+walkAnimName+"8"),
            walkAtlas.textureNamed(unitName+walkAnimName+"9"),
            walkAtlas.textureNamed(unitName+walkAnimName+"10"),
            walkAtlas.textureNamed(unitName+walkAnimName+"11"),
            walkAtlas.textureNamed(unitName+walkAnimName+"12"),
            walkAtlas.textureNamed(unitName+walkAnimName+"13"),
            walkAtlas.textureNamed(unitName+walkAnimName+"14"),
            walkAtlas.textureNamed(unitName+walkAnimName+"15"),
            walkAtlas.textureNamed(unitName+walkAnimName+"16"),
            walkAtlas.textureNamed(unitName+walkAnimName+"17"),
            walkAtlas.textureNamed(unitName+walkAnimName+"18"),
            walkAtlas.textureNamed(unitName+walkAnimName+"19"),
            walkAtlas.textureNamed(unitName+walkAnimName+"20")
        ], timePerFrame: 0.05)
        
        var attackTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(unitName+attackAnimName+"0"),
            walkAtlas.textureNamed(unitName+attackAnimName+"1"),
            walkAtlas.textureNamed(unitName+attackAnimName+"2"),
            walkAtlas.textureNamed(unitName+attackAnimName+"3"),
            walkAtlas.textureNamed(unitName+attackAnimName+"4"),
            walkAtlas.textureNamed(unitName+attackAnimName+"5"),
            walkAtlas.textureNamed(unitName+attackAnimName+"6"),
            walkAtlas.textureNamed(unitName+attackAnimName+"7"),
            walkAtlas.textureNamed(unitName+attackAnimName+"8"),
            walkAtlas.textureNamed(unitName+attackAnimName+"9"),
            walkAtlas.textureNamed(unitName+attackAnimName+"10"),
            walkAtlas.textureNamed(unitName+attackAnimName+"11"),
            walkAtlas.textureNamed(unitName+attackAnimName+"12"),
        ], timePerFrame: 0.05)
        
        var standTextures = SKAction.animateWithTextures([
            attackAtlas.textureNamed(unitName+standAnimName+"0")
        ], timePerFrame: 0.1)
        
        self.walkAnim = SKAction.repeatActionForever(walkTextures)
        self.standAnim = SKAction.repeatActionForever(standTextures)
        self.attackAnim = SKAction.repeatAction(attackTextures, count: 1)
        
        self.sprite = SKSpriteNode(imageNamed:"Character1BaseColorization-Stand")
        var mir = SKAction.scaleXTo(-0.25, duration: 0.0)
        
        //self.sprite.runAction(self.walkAnim)
        //self.sprite.runAction(mir)
        
        
    }
    
    
    func apply(order: Order)
    {
        println("APPLY")
        if order is Move
        {
            println("APPLYMOVE")
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
        println("MOVING")
        let charPos = sprite.position
        println(charPos)
        let xdif = destination.x-charPos.x
        let ydif = destination.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/speed
        let movementAction = SKAction.moveTo(destination, duration:NSTimeInterval(duration))
        let walkAnimationAction = self.walkAnim
        let action = SKAction.group([walkAnimationAction, movementAction])
        
        
        //sprite.runAction(action)
        self.sprite.runAction(movementAction)
        //sprite.runAction(self.walkAnim)
    }
    
}
