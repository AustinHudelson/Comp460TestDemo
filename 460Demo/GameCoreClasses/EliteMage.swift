//
//  EliteWarrior.swift
//  460Demo
//
//  Created by Austin Hudelson on 4/10/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(EliteMage)
class EliteMage: Unit, PType
{
    
    var DS_FrostingA = false
    var DS_FrostingB = false
    var DS_FrostingC = false
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        restoreProperties(EliteMage.self, receivedData: receivedData)
        
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
        self.type = "EliteMage"
        self.health = 250.0
        self.maxhealth = Attribute(baseValue: 250.0)
        self.DS_healthregen = 0
        self.attackSpeed = Attribute(baseValue: 0.8)
        self.attackDamage = Attribute(baseValue: 10.0)
        self.speed = Attribute(baseValue: 120.0)
        self.attackRange = 200.0
        self.isEnemy = true
        self.xSize = 400.0
        self.ySize = 400.0
        
        self.damageMultiplier.addModifier("eliteWar", value: 1.0)
        
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
        abilityAnim = getAnimationAction(AnimationName, classPrefix: classPrefix, animGroupName: abilityAnimName, timePerFrame: 0.02)
        
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
        //Modify enemy health and damage for 1 or 2 players
        if (self.isEnemy == true){
            if (Game.global.playerCount == 1){
                self.maxhealth.addModifier("1P", value: 0.5773) //Sqrt of 1/3
                self.health = self.maxhealth.get()
                self.attackDamage.addModifier("1P", value: 0.5773)
            } else if (Game.global.playerCount == 2){
                self.maxhealth.addModifier("2P", value: 0.8165) //Sqrt of 2/3
                self.health = self.maxhealth.get()
                self.attackDamage.addModifier("2P", value: 0.8165)
            }
        }
        super.addUnitToGameScene(gameScene, pos: pos)
        self.sendOrder(RoamAttack(receiverIn: self))
        self.applyTint("Enemy", red: 0.1, blue: 2.0, green: 0.3)
    }
    
    override func takeDamage(damage: CGFloat){
        super.takeDamage(damage)
        checkFrostJumpTime()
    }
    
    override func synchronize(receivedLife: CGFloat, receivedPosition: CGPoint, tID: String){
        if (receivedLife <= 0 || !(self.currentOrder is Idle || self.currentOrder is FrostStrikeVolly)){
            super.synchronize(receivedLife, receivedPosition: receivedPosition, tID: tID)
        }
        let percent = self.health/self.maxhealth.get()
        checkFrostJumpTime()
    }
    
    override func weaponHandle(target: Unit){
        let projectile = MageBolt(target: target, caster: self)
    }
    
    func checkFrostJumpTime(){
        let percent = self.health/self.maxhealth.get()
        if (percent <= 0.75 && DS_FrostingA == false){
            DS_FrostingA = true
            self.sendOrder(FrostStrikeVolly(receiverIn:self))
            return
        }
        if (percent <= 0.5 && DS_FrostingB == false){
            DS_FrostingB = true
            self.sendOrder(FrostStrikeVolly(receiverIn:self))
            return
        }
        if (percent <= 0.25 && DS_FrostingC == false){
            DS_FrostingC = true
            self.sendOrder(FrostStrikeVolly(receiverIn:self))
            return
        }
    }
}
