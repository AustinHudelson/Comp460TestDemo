//
//  Warrior.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(EnemyMage)
class EnemyMage: Unit, PType
{
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        restoreProperties(Warrior.self, receivedData: receivedData)
        
        //Initializes all the DS_ animations
        initializeAnimations()
        /* Sprite setup */
        let spawnLoc = CGPoint(x: (receivedData["posX"] as CGFloat), y: (receivedData["posY"] as CGFloat))
        sprite.position = spawnLoc
        self.sprite.zPosition = Game.global.scene!.frame.maxY - self.sprite.position.y + 1
        self.DS_health_bar.zPosition = Game.global.scene!.frame.maxY - self.sprite.position.y + 3
    }
    
    override init(ID:String, spawnLocation: CGPoint)
    {
        super.init(ID:ID, spawnLocation: spawnLocation)
        //INITILIZE THE UNITS STATS HERE!!!
        self.type = "EnemyMage"
        self.health = 45.0
        self.maxhealth = Attribute(baseValue: 45.0)
        self.DS_healthregen = 0
        self.attackSpeed = Attribute(baseValue:  1.88)
        self.attackDamage = Attribute(baseValue: 6.0)
        self.speed = Attribute(baseValue: 50.0)
        self.attackRange = 300.0
        self.isEnemy = true
        self.xSize = 250.0
        self.ySize = 250.0
        
        //Initializes all the DS_ animations
        initializeAnimations()
        self.sprite.position = spawnLocation
        
        self.sprite.zPosition = Game.global.scene!.frame.maxY - self.sprite.position.y + 1
        self.DS_health_bar.zPosition = Game.global.scene!.frame.maxY - self.sprite.position.y + 3
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
   
    override func addUnitToGameScene(gameScene: GameScene, pos: CGPoint) {
        //Enemies have a red health text color
        self.DS_health_txt.fontColor = UIColor.redColor()
        
        super.addUnitToGameScene(gameScene, pos: pos)
        
        //Give a light red tint.
        self.applyTint("Enemy", red: 0.75, blue: 0.2, green: 0.9)
        
        //Mage should walk on to the screen before being allowed to attack.
        if Game.global.scene != nil && (self.sprite.position.x < CGRectGetMinX(Game.global.scene!.frame)) {
            //Mage is off the side of the screen on the left side. Send order to move on to the screen then roam attack.
            self.move(CGPoint(x: CGRectGetMinX(Game.global.scene!.frame)+80, y: self.sprite.position.y), complete: {
                self.sendOrder(RoamAttack(receiverIn: self))
            })
        } else if (Game.global.scene != nil && (self.sprite.position.x > CGRectGetMaxX(Game.global.scene!.frame))) {
            //Mage is off the side of the screen on the right side. Send order to move on to the screen then roam attack.
            self.move(CGPoint(x: CGRectGetMaxX(Game.global.scene!.frame)-80, y: self.sprite.position.y), complete: {
                self.sendOrder(RoamAttack(receiverIn: self))
            })
        } else {
            self.sendOrder(RoamAttack(receiverIn: self))
        }
    }
    
    override func weaponHandle(target: Unit){
        let projectile = MageBolt(target: target, caster: self)
    }
}
