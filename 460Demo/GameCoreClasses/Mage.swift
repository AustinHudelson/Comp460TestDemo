//
//  Mage.swift
//  460Demo
//
//  Created by Austin on 3/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(Mage)
class Mage: Unit, PType
{
    
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
        self.type = "Mage"
        self.health = 80
        self.maxhealth = Attribute(baseValue: 80.0)
        self.DS_healthregen = 0
        self.speed = Attribute(baseValue: 80.0)
        self.DS_attackRange = 1000.0
        self.attackSpeed = Attribute(baseValue: 2.0)
        self.attackDamage = Attribute(baseValue: 5.0)
        self.isEnemy = false
        self.DS_xSize = 300.0
        self.DS_ySize = 300.0
        
        //Initializes all the DS_ animations
        initializeAnimations()
        self.sprite.position = spawnLocation
        
        /* Initialize Warrior buttons. They will automatically be added to the scene */
        let Button0: Ability = ButtonFrostbolt(slot: 0)
        let Button1: Ability = ButtonFlameStrike(slot: 1)
        let Button2: Ability = ButtonBlink(slot: 2)
    }
    
    func initializeAnimations() {
        let AnimationName = "character1basecolorization"
        
        let classPrefix = "NewMage"
        
        let standAnimName = "-attack"
        let walkAnimName = "-walk"
        let attackAnimName = "-attack"
        let abilityAnimName = "-ability"
        let deathAnimName = "-death"
        let stumbleAnimName = "-stumble"
        
        var Atlas: SKTextureAtlas
        
        var standAnim: SKAction
        var walkAnim: SKAction
        var attackAnim: SKAction
        var abilityAnim: SKAction
        var deathAnim: SKAction
        var stumbleAnim: SKAction
        
        /* stand animation */
        Atlas = SKTextureAtlas(named: classPrefix+standAnimName)
        let textureName = String(format: "%@%@0", AnimationName, standAnimName)
        var standTextures = [Atlas.textureNamed(textureName)]
        standAnim = SKAction.animateWithTextures(standTextures, timePerFrame: 0.1)
        
        /* walk animation */
        walkAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: walkAnimName, timePerFrame: 0.035)
        
        /* attack animation */
        attackAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: attackAnimName, timePerFrame: 0.05)
        
        /* ability animation */
        abilityAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: abilityAnimName, timePerFrame: 0.1)
        
        /* death animation */
        deathAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: deathAnimName, timePerFrame: 0.05)
        
        /* stumble animation */
        stumbleAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: stumbleAnimName, timePerFrame: 0.05)
        
        self.DS_standAnim = SKAction.repeatActionForever(standAnim)
        self.DS_walkAnim = SKAction.repeatActionForever(walkAnim)
        self.DS_attackAnim = SKAction.repeatAction(attackAnim, count: 1)
        self.DS_abilityAnim = SKAction.repeatAction(abilityAnim, count: 1)
        self.DS_deathAnim = SKAction.repeatAction(deathAnim, count: 1)
        self.DS_stumbleAnim = SKAction.repeatAction(stumbleAnim, count: 1)
        
        /* Sprite setup */
        self.sprite = SKSpriteNode(imageNamed: "NewMageStand200x200")
        
        self.sprite.runAction(self.DS_standAnim!, withKey: "stand")
        self.sprite.runAction(SKAction.resizeToWidth(self.DS_xSize, duration:0.0))
        self.sprite.runAction(SKAction.resizeToHeight(self.DS_ySize, duration:0.0))
        
    }
    
//    /*
//    * Initializes the animations for this class. And creates the sprite
//    */
//    func initializeAnimations(){
//        //
//        //Define Animations here
//        //
//        
//        let animPrefix = "NewMage"
//        var Atlas:SKTextureAtlas
//        let walkAnimName = "-walk"
//        let attackAnimName = "-attack"
//        let abilityAnimName = "-ability"
//        let deathAnimName = "-death"
//        let stumbleAnimName = "-stumble"
//        let standAnimName = "-attack"
//        
//        Atlas = SKTextureAtlas(named: animPrefix+walkAnimName)
//        var walkTextures = SKAction.animateWithTextures([
//            Atlas.textureNamed(AnimationName+walkAnimName+"0"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"1"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"2"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"3"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"4"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"5"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"6"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"7"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"8"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"9"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"10"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"11"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"12"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"13"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"14"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"15"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"16"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"17"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"18"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"19"),
//            Atlas.textureNamed(AnimationName+walkAnimName+"20"),
//            ], timePerFrame: 0.035)
//        
//        Atlas = SKTextureAtlas(named: animPrefix+attackAnimName)
//        var attackTextures = SKAction.animateWithTextures([
//            Atlas.textureNamed(AnimationName+attackAnimName+"0"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"1"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"2"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"3"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"4"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"5"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"6"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"7"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"8"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"9"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"10"),
//            Atlas.textureNamed(AnimationName+attackAnimName+"11"),
//            ], timePerFrame: 0.05)
//        
//        Atlas = SKTextureAtlas(named: animPrefix+deathAnimName)
//        var deathTextures = SKAction.animateWithTextures([
//            Atlas.textureNamed(AnimationName+deathAnimName+"0"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"1"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"2"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"3"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"4"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"5"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"6"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"7"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"8"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"9"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"10"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"11"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"12"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"13"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"14"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"15"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"16"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"17"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"18"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"19"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"20"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"21"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"22"),
//            Atlas.textureNamed(AnimationName+deathAnimName+"23"),
//            ], timePerFrame: 0.05)
//        
//        Atlas = SKTextureAtlas(named: animPrefix+abilityAnimName)
//        var abilityTextures = SKAction.animateWithTextures([
//            Atlas.textureNamed(AnimationName+abilityAnimName+"0"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"1"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"2"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"3"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"4"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"5"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"6"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"7"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"8"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"9"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"10"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"11"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"12"),
//            Atlas.textureNamed(AnimationName+abilityAnimName+"13"),
//            ], timePerFrame: 0.1)
//        
//        Atlas = SKTextureAtlas(named: animPrefix+stumbleAnimName)
//        var stumbleTextures = SKAction.animateWithTextures([
//            Atlas.textureNamed(AnimationName+stumbleAnimName+"0"),
//            Atlas.textureNamed(AnimationName+stumbleAnimName+"1"),
//            Atlas.textureNamed(AnimationName+stumbleAnimName+"2"),
//            Atlas.textureNamed(AnimationName+stumbleAnimName+"3"),
//            Atlas.textureNamed(AnimationName+stumbleAnimName+"4")
//            ], timePerFrame: 0.05)
//        
//        Atlas = SKTextureAtlas(named: animPrefix+standAnimName)
//        var standTextures = SKAction.animateWithTextures([
//            Atlas.textureNamed(AnimationName+standAnimName+"0")
//            ], timePerFrame: 0.1)
//        
//        self.DS_walkAnim = SKAction.repeatActionForever(walkTextures)
//        self.DS_standAnim = SKAction.repeatActionForever(standTextures)
//        self.DS_attackAnim = SKAction.repeatAction(attackTextures, count: 1)
//        self.DS_stumbleAnim = SKAction.repeatAction(stumbleTextures, count: 1)
//        self.DS_deathAnim = SKAction.repeatAction(deathTextures, count: 1)
//        self.DS_abilityAnim = SKAction.repeatAction(abilityTextures, count: 1)
//        
//        /* Sprite setup */
//        self.sprite = SKSpriteNode(imageNamed: "MageStand350x350")
//        //self.DS_health_txt.fontColor = UIColor.redColor()
//        self.sprite.runAction(self.DS_standAnim!, withKey: "stand")
//        self.sprite.runAction(SKAction.resizeToWidth(self.xSize, duration:0.0))
//        self.sprite.runAction(SKAction.resizeToHeight(self.ySize, duration:0.0))
//        
//        
//    }
    
    override func weaponHandle(target: Unit){
        let projectile = MageBolt(target: target, caster: self)
    }
}
