//
//  Warrior.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(Warrior)
class Warrior: Unit, PType
{
    var AnimationName = "Character1BaseColorization"
    var testProperty = "WRONG!"
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        
        restoreProperties(Warrior.self, receivedData: receivedData)
        
        //Initializes all the DS_ animations
        initializeAnimations()
        /* Sprite setup */
        sprite = SKSpriteNode(imageNamed: "Mage")
        let spawnLoc = CGPoint(x: (receivedData["posX"] as CGFloat), y: (receivedData["posY"] as CGFloat))
        sprite.position = spawnLoc
        self.sprite.runAction(self.DS_standAnim)
    }
    
    override init(ID:String, health: Int, speed: CGFloat, spawnLocation: CGPoint)
    {
        super.init(ID:ID, health: health, speed: speed, spawnLocation: spawnLocation)
        self.health = 100
        self.maxhealth = 100
        self.healthregen = 1
        self.sprite.xScale = 1.0
        self.sprite.yScale = 1.0
        self.testProperty = "kinda Wrong!"
        self.setValue("TOTALLY RIGHT!", forKey: "testProperty")
        
        self.type = "Warrior"
        
        //Initializes all the DS_ animations
        initializeAnimations()
        /* Sprite setup */
        sprite = SKSpriteNode(imageNamed: "Mage")
        sprite.position = spawnLocation
        self.sprite.runAction(self.DS_standAnim)
    }
    
    /*
    * Initializes the animations for this class
    */
    func initializeAnimations(){
        //
        //Define Animations here
        //
        
        let walkAtlas = SKTextureAtlas(named: "Walk")
        let attackAtlas = SKTextureAtlas(named: "Attack")
        let walkAnimName = "-Walk2"
        let attackAnimName = "-Attack"
        let standAnimName = "-Walk2"
        
        var walkTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(AnimationName+walkAnimName+"0"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"1"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"2"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"3"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"4"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"5"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"6"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"7"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"8"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"9"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"10"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"11"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"12"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"13"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"14"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"15"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"16"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"17"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"18"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"19"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"20")
            ], timePerFrame: 0.05)
        
        var attackTextures = SKAction.animateWithTextures([
            attackAtlas.textureNamed(AnimationName+attackAnimName+"0"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"1"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"2"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"3"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"4"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"5"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"6"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"7"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"8"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"9"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"10"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"11"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"12"),
            ], timePerFrame: 0.05)
        
        var standTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(AnimationName+standAnimName+"0")
            ], timePerFrame: 0.1)
        
        self.DS_walkAnim = SKAction.repeatActionForever(walkTextures)
        self.DS_standAnim = SKAction.repeatActionForever(standTextures)
        self.DS_attackAnim = SKAction.repeatAction(attackTextures, count: 1)
    }
}
