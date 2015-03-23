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
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        
        restoreProperties(Warrior.self, receivedData: receivedData)
        
        /* Sprite setup. Needs to be done in every subclass of Unit */
        initializeAnimations()
        self.sprite.position = CGPoint(x: (receivedData["posX"] as CGFloat), y: (receivedData["posY"] as CGFloat))
        self.sprite.zPosition = 1
    }
    
    override init(ID:String, spawnLocation: CGPoint)
    {
        super.init(ID:ID, spawnLocation: spawnLocation)
        //INITILIZE THE UNITS STATS HERE!!!
        self.type = "Warrior"
        self.health = 100
        self.maxhealth = Attribute(baseValue: 100)
        self.healthregen = 1
        self.speed = Attribute(baseValue: 90.0)
        self.attackSpeed = Attribute(baseValue: 1.88)
        self.attackRange = 20.0
        self.attackDamage = Attribute(baseValue: 10.0)
        self.isEnemy = false
        self.xSize = 300.0
        self.ySize = 300.0
        
        //Initializes all the DS_ animations
        initializeAnimations()
        self.sprite.position = spawnLocation
        self.sprite.zPosition = 1
        /* Initialize Warrior buttons. They will automatically be added to the scene */
        let Button0: Ability = ButtonTaunt(slot: 0)
        let Button1: Ability = ButtonEnrage(slot: 1)
        //let Button2: Ability = ButtonTaunt(slot: 2)
    }
    
    /*
    * Initializes the animations for this class. And creates the sprite
    */
    func initializeAnimations(){
        //
        //Define Animations here
        //
        
        let animPrefix = "Warrior"
        var Atlas: SKTextureAtlas
        let walkAnimName = "-walk"
        let attackAnimName = "-attack"
        let abilityAnimName = "-ability"
        let deathAnimName = "-death"
        let stumbleAnimName = "-stumble"
        let standAnimName = "-attack"
        
        Atlas = SKTextureAtlas(named: animPrefix+walkAnimName)
        var walkTextures = SKAction.animateWithTextures([
            SKTexture(imageNamed: AnimationName+walkAnimName+"0"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"1"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"2"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"3"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"4"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"5"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"6"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"7"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"8"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"9"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"10"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"11"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"12"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"13"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"14"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"15"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"16"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"17"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"18"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"19"),
            SKTexture(imageNamed: AnimationName+walkAnimName+"20"),
            ], timePerFrame: 0.035)
        
        Atlas = SKTextureAtlas(named: animPrefix+attackAnimName)
        var attackTextures = SKAction.animateWithTextures([
            SKTexture(imageNamed: AnimationName+attackAnimName+"0"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"1"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"2"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"3"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"4"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"5"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"6"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"7"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"8"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"9"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"10"),
            SKTexture(imageNamed: AnimationName+attackAnimName+"11"),
            ], timePerFrame: 0.05)
        
        Atlas = SKTextureAtlas(named: animPrefix+deathAnimName)
        var deathTextures = SKAction.animateWithTextures([
            SKTexture(imageNamed: AnimationName+deathAnimName+"0"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"1"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"2"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"3"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"4"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"5"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"6"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"7"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"8"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"9"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"10"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"11"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"12"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"13"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"14"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"15"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"16"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"17"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"18"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"19"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"20"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"21"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"22"),
            SKTexture(imageNamed: AnimationName+deathAnimName+"23"),
            ], timePerFrame: 0.05)
        
        Atlas = SKTextureAtlas(named: animPrefix+abilityAnimName)
        var abilityTextures = SKAction.animateWithTextures([
            SKTexture(imageNamed: AnimationName+abilityAnimName+"0"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"1"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"2"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"3"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"4"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"5"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"6"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"7"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"8"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"9"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"10"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"11"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"12"),
            SKTexture(imageNamed: AnimationName+abilityAnimName+"13"),
            ], timePerFrame: 0.1)
        
        Atlas = SKTextureAtlas(named: animPrefix+stumbleAnimName)
        var stumbleTextures = SKAction.animateWithTextures([
            SKTexture(imageNamed: AnimationName+stumbleAnimName+"0"),
            SKTexture(imageNamed: AnimationName+stumbleAnimName+"1"),
            SKTexture(imageNamed: AnimationName+stumbleAnimName+"2"),
            SKTexture(imageNamed: AnimationName+stumbleAnimName+"3"),
            SKTexture(imageNamed: AnimationName+stumbleAnimName+"4")
            ], timePerFrame: 0.05)
        
        Atlas = SKTextureAtlas(named: animPrefix+standAnimName)
        var standTextures = SKAction.animateWithTextures([
            SKTexture(imageNamed: AnimationName+standAnimName+"0")
            ], timePerFrame: 0.1)
        
        self.DS_walkAnim = SKAction.repeatActionForever(walkTextures)
        self.DS_standAnim = SKAction.repeatActionForever(standTextures)
        self.DS_attackAnim = SKAction.repeatAction(attackTextures, count: 1)
        self.DS_stumbleAnim = SKAction.repeatAction(stumbleTextures, count: 1)
        self.DS_deathAnim = SKAction.repeatAction(deathTextures, count: 1)
        self.DS_abilityAnim = SKAction.repeatAction(abilityTextures, count: 1)
        
        /* Sprite setup */
        self.sprite = SKSpriteNode(imageNamed: "WarriorStand350x350")
        //self.DS_health_txt.fontColor = UIColor.redColor()
        self.sprite.runAction(self.DS_standAnim!, withKey: "stand")
        self.sprite.runAction(SKAction.resizeToWidth(self.xSize, duration:0.0))
        self.sprite.runAction(SKAction.resizeToHeight(self.ySize, duration:0.0))
    }
}
