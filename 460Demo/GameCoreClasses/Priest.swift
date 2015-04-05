//
//  Mage.swift
//  460Demo
//
//  Created by Austin on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(Priest)
class Priest: Unit, PType
{
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        
        restoreProperties(Priest.self, receivedData: receivedData)
        
        /* Sprite setup. Needs to be done in every subclass of Unit */
        initializeAnimations()
        self.sprite.position = CGPoint(x: (receivedData["posX"] as CGFloat), y: (receivedData["posY"] as CGFloat))
        self.sprite.zPosition = 1
    }
    
    override init(ID:String, spawnLocation: CGPoint)
    {
        super.init(ID:ID, spawnLocation: spawnLocation)
        //INITILIZE THE UNITS STATS HERE!!!
        self.type = "Priest"
        self.health = 80
        self.maxhealth = Attribute(baseValue: 80.0)
        self.DS_healthregen = 0
        self.speed = Attribute(baseValue: 80.0)
        self.attackRange = 1000.0
        self.attackSpeed = Attribute(baseValue: 2.0)
        self.attackDamage = Attribute(baseValue: 7.5)
        self.isEnemy = false
        self.xSize = 300.0
        self.ySize = 300.0
        
        self.isHealer = true
        
        //Initializes all the DS_ animations
        initializeAnimations()
        self.sprite.position = spawnLocation
        
        /* Initialize Warrior buttons. They will automatically be added to the scene */
        let Button0: Ability = ButtonAreaHeal(slot: 0)
        let Button1: Ability = ButtonBlindingFlash(slot: 1)
        let Button2: Ability = ButtonSoulExchange(slot: 2)
    }
    
    func initializeAnimations() {
        var AnimationName = "character1BaseColorization"
        
        let classPrefix = "Priest"
        
        let standAnimName = "-stand"
        let walkAnimName = "-walk"
        let attackAnimName = "-heal"
        let abilityAnimName = "-ability"
        let deathAnimName = "-death"
        let stumbleAnimName = "-stumble"
        
        var standAnim: SKAction
        var walkAnim: SKAction
        var attackAnim: SKAction
        var abilityAnim: SKAction
        var deathAnim: SKAction
        var stumbleAnim: SKAction
        
        /* stand animation */
        standAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: standAnimName, timePerFrame: 0.2)
        
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
        self.sprite = SKSpriteNode(imageNamed: "PriestStand200x200")
        
        self.sprite.runAction(self.DS_standAnim!, withKey: "stand")
        self.sprite.runAction(SKAction.resizeToWidth(self.xSize, duration:0.0))
        self.sprite.runAction(SKAction.resizeToHeight(self.ySize, duration:0.0))
        
    }

    override func weaponHandle(target: Unit){
        //Setup heal particle emitter
        let emitterPath: String = NSBundle.mainBundle().pathForResource("HealParticle", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as SKEmitterNode
        //emitterNode.position = self.sprite!.position
        emitterNode.name = "Healing"
        emitterNode.zPosition = self.sprite.zPosition+2
        emitterNode.targetNode = target.sprite
        
        let halfWaitAction: SKAction = SKAction.waitForDuration(NSTimeInterval(0.2))
        let removeNodeBlock: SKAction = SKAction.runBlock({
            emitterNode.removeFromParent()
        })
        let applyHealingBlock: SKAction = SKAction.runBlock({
            self.dealHealing(self.attackDamage.get(), target: target)
        })
        
        //Start the emitter node, wait half, heal, wait half again, remove the emitter node
        self.sprite.addChild(emitterNode)   //Start the emitter node
        self.sprite.runAction(SKAction.sequence([halfWaitAction, applyHealingBlock, halfWaitAction, removeNodeBlock]))
    }
}
