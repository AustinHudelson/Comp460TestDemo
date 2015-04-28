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
    
    var DS_Frosting = false
    
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
        self.attackSpeed = Attribute(baseValue: 1.1)
        self.attackDamage = Attribute(baseValue: 8.0)
        self.speed = Attribute(baseValue: 120.0)
        self.attackRange = 600.0
        self.isEnemy = true
        self.xSize = 325.0
        self.ySize = 325.0
        
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
        //Enemy has a red health text color
        //self.DS_health_txt.fontColor = UIColor.redColor()
        super.addUnitToGameScene(gameScene, pos: pos)
        self.sendOrder(RoamAttack(receiverIn: self))
        self.applyTint("Enemy", red: 1.0, blue: 0.75, green: 0.75)
        
        //Start Armor Up Loop
        let commandArmorUp: SKAction = SKAction.runBlock({
            self.sendOrder(EnemyArmorUp(receiverIn: self))
        })
        //Delay set to double the duration of enemy Armor up for 50% damage reduction
        let commandArmorUpDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(16.0))
        let initialCommandArmorUpDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(0.0))
        let commandLoop: SKAction = SKAction.repeatActionForever(SKAction.sequence([commandArmorUp, commandArmorUpDelay]))
        self.sprite.runAction(SKAction.sequence([initialCommandArmorUpDelay, commandLoop]))
    }
    
    override func takeDamage(damage: CGFloat){
        super.takeDamage(damage)
        let percent = self.health/self.maxhealth.get()
        if (percent <= 0.75 && DS_Frosting == false) {
            DS_Frosting = true
            //Start Frost Loop
            let commandFrostStrike: SKAction = SKAction.runBlock({
                self.sendOrder(FrostStrikeVolly(receiverIn: self))
            })
            //Delay set to double the duration of enemy Armor up for 50% damage reduction
            let commandFrostStrikeDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(20.0))
            let initialCommandFrostStrikeDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(10.0))
            let commandLoop: SKAction = SKAction.repeatActionForever(SKAction.sequence([commandFrostStrikeDelay, commandFrostStrike]))
            self.sprite.runAction(SKAction.sequence([initialCommandFrostStrikeDelay, commandLoop]))
        }
    }
    
    override func synchronize(receivedLife: CGFloat, receivedPosition: CGPoint, tID: String){
        super.synchronize(receivedLife, receivedPosition: receivedPosition, tID: tID)
        let percent = self.health/self.maxhealth.get()
        if (percent <= 0.75 && DS_Frosting == false) {
            DS_Frosting = true
            //Start Frost Loop
            let commandFrostStrike: SKAction = SKAction.runBlock({
                self.sendOrder(FrostStrikeVolly(receiverIn: self))
            })
            //Delay set to double the duration of enemy Armor up for 50% damage reduction
            let commandFrostStrikeDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(20.0))
            let initialCommandFrostStrikeDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(10.0))
            let commandLoop: SKAction = SKAction.repeatActionForever(SKAction.sequence([commandFrostStrikeDelay, commandFrostStrike]))
            self.sprite.runAction(SKAction.sequence([initialCommandFrostStrikeDelay, commandLoop]))
        }
    }
}
