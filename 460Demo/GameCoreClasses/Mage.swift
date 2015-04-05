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
        
        
        restoreProperties(Mage.self, receivedData: receivedData)
        
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
        self.attackRange = 1000.0
        self.attackSpeed = Attribute(baseValue: 2.0)
        self.attackDamage = Attribute(baseValue: 5.0)
        self.isEnemy = false
        self.xSize = 300.0
        self.ySize = 300.0
        
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
        self.sprite.runAction(SKAction.resizeToWidth(self.xSize, duration:0.0))
        self.sprite.runAction(SKAction.resizeToHeight(self.ySize, duration:0.0))
        
    }
      
    override func weaponHandle(target: Unit){
        let projectile = MageBolt(target: target, caster: self)
    }
}
