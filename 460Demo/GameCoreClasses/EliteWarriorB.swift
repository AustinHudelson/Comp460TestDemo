//
//  EliteWarrior.swift
//  460Demo
//
//  Created by Austin Hudelson on 4/10/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//
//  THIS IS A COPY OF ELITEWARRIOR EXCEPT THIS WARRIOR DELAYS THE ARMOR UP COMMAND
//  USE TO CREATE ELETEWARRIORS THAT ALTERNATE ARMOR UPS
//

import SpriteKit
import Foundation

@objc(EliteWarriorB)
class EliteWarriorB: Unit, PType
{
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        restoreProperties(EliteWarriorB.self, receivedData: receivedData)
        
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
        self.type = "EliteWarriorB"
        self.health = 170.0
        self.maxhealth = Attribute(baseValue: 170.0)
        self.DS_healthregen = 0
        self.attackSpeed = Attribute(baseValue: 1.25)
        self.attackDamage = Attribute(baseValue: 15.0)
        self.speed = Attribute(baseValue: 120.0)
        self.attackRange = 20.0
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
        
        let classPrefix = "Warrior"
        
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
        self.sprite = SKSpriteNode(imageNamed: "WarriorStand200x200")
        
        self.sprite.runAction(self.DS_standAnim!, withKey: "stand")
        self.sprite.runAction(SKAction.resizeToWidth(self.xSize, duration:0.0))
        self.sprite.runAction(SKAction.resizeToHeight(self.ySize, duration:0.0))
    }
    
    
    override func addUnitToGameScene(gameScene: GameScene, pos: CGPoint) {
        //Modify enemy health and damage for 1 or 2 players
        if (self.isEnemy == true){
            if (Game.global.playerCount == 1){
                self.maxhealth.addModifier("1P", value: 0.5) //Sqrt of 1/3
                self.health = self.maxhealth.get()
                self.attackDamage.addModifier("1P", value: 0.5)
            } else if (Game.global.playerCount == 2){
                self.maxhealth.addModifier("2P", value: 0.8165) //Sqrt of 2/3
                self.health = self.maxhealth.get()
                self.attackDamage.addModifier("2P", value: 0.8165)
            }
        }
        super.addUnitToGameScene(gameScene, pos: pos)
        self.sendOrder(RoamAttack(receiverIn: self))
        self.applyTint("Enemy", red: 1.0, blue: 0.75, green: 0.75)
        
        //Start Armor Up Loop
        let commandArmorUp: SKAction = SKAction.runBlock({
            if (self.alive == true){
                self.sendOrder(EnemyArmorUp(receiverIn: self))
            }
        })
        //Delay set to double the duration of enemy Armor up for 50% damage reduction
        let commandArmorUpDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(16.0))
        let initialCommandArmorUpDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(8.0))
        let commandLoop: SKAction = SKAction.repeatActionForever(SKAction.sequence([commandArmorUp, commandArmorUpDelay]))
        self.sprite.runAction(SKAction.sequence([initialCommandArmorUpDelay, commandLoop]))
        
        //Retarget Loop
        let retargetDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(20.0))
        let initialRetargetDelay: SKAction = SKAction.waitForDuration(NSTimeInterval(20.0))
        let retargetAction: SKAction = SKAction.runBlock({
            if (self.alive == true){
                self.retarget()
            }
        })
        let retargetLoop: SKAction = SKAction.repeatActionForever(SKAction.sequence([retargetAction, retargetDelay]))
        self.sprite.runAction(SKAction.sequence([initialRetargetDelay, retargetLoop]))
    }
    
    /*
    Causes the warrior to find a new target. If an EliteWarriorB exists, the warrior will attempt
    to get a differant target than the current target of the EliteWarriorB
    */
    func retarget(){
        //Retarget roamattack to a target not being attacked by an EliteWarriorB
        var buddyWarrior: Unit?
        var dontAttack: Unit?
        for (id, unit) in Game.global.enemyMap {
            if unit is EliteWarrior {
                buddyWarrior = unit
                break
            }
        }
        //Determine attack target of buddyWarrior
        if (buddyWarrior != nil) && (buddyWarrior!.DS_attackTarget != nil) {
            dontAttack = buddyWarrior!.DS_attackTarget!
        }
        //Get a list of all possible targets
        var potentialTargets: Array<Unit> = []
        for (id, unit) in Game.global.playerMap {
            if unit.alive == true {
                potentialTargets.append(unit)
            }
        }
        //If there are atleast 2 targets, attempt to remove buddyWarrior's target
        if (potentialTargets.count >= 2 && dontAttack != nil){
            var i = 0
            while i < potentialTargets.count {
                if potentialTargets[i] == dontAttack {
                    potentialTargets.removeAtIndex(i)
                    break
                }
                i++
            }
        }
        
        var newTarget: Unit?
        //If there is atleast 1 potential target assign one at random
        if (potentialTargets.count >= 1){
            //Get the farthest away player
            var nearby: Unit? = nil
            var near: CGFloat = 0.0
            for unit in potentialTargets {
                var p2 = unit.sprite.position
                var dist = Game.global.getRelativeDistance(self.sprite.position, p2:p2)
                if dist >= near{
                    nearby = unit
                    near = dist
                }
            }
            newTarget = nearby
        } else {
            return
        }
        
        if !(self.currentOrder is RoamAttack){
            return
        }
        
        if newTarget != nil{
            (self.currentOrder as RoamAttack).redirect(newTarget!)
        }
    }
    
    override func kill(){
        for (id, unit) in Game.global.enemyMap {
            if unit is EliteWarrior {
                unit.sendOrder(EnemyPermEnrage(receiverIn: unit))
            }
        }
        super.kill()
    }
}