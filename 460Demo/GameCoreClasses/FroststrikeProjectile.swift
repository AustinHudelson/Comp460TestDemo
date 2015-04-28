//
//  MageBolt.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/23/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class FroststrikeProjectile: Projectile {
    var caster: Unit
    var potentialTargets: Array<Unit> = []
    
    let searchArea: CGFloat = 70.0      /* Thickness of the fireball's search area */
    let damage: CGFloat = 20.0           /* Amount of damage done */
    let searchRate: NSTimeInterval = NSTimeInterval(0.125) //.125 is 8 updates a second.
    
    init(caster: Unit){
        self.caster = caster
        //Create a copy of the enemy list.
        for (id, unit) in Game.global.playerMap {
            potentialTargets.append(unit)
        }
        super.init()
        
        //Determine coordinates of projectile movement
        var startPosition: CGPoint
        var endPosition: CGPoint
        if (caster.DS_isFacingLeft){
            //Projectile moves to the left off the screen at 0
            let startX = caster.sprite.position.x - 50.0
            let startY = caster.sprite.position.y
            let endX = CGRectGetMinX(Game.global.scene!.frame)-100.0
            let endY = caster.sprite.position.y
            
            startPosition = CGPoint(x: startX, y: startY)
            endPosition = CGPoint(x: endX, y: endY)
            
        } else {
            //Projectile moves to the right off the screen at getFrameMaxX()
            let startX = caster.sprite.position.x + 50.0
            let startY = caster.sprite.position.y
            let endX = CGRectGetMaxX(Game.global.scene!.frame)+100.0
            let endY = caster.sprite.position.y
            
            startPosition = CGPoint(x: startX, y: startY)
            endPosition = CGPoint(x: endX, y: endY)
        }
        
        self.sprite = SKSpriteNode(imageNamed: "Spark")
        
        //Determine start position of the projectile!!
        self.sprite!.position = startPosition
        self.sprite!.zPosition = caster.sprite.zPosition+1
        
        let emitterPath: String = NSBundle.mainBundle().pathForResource("FroststrikeParticle", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as SKEmitterNode
        //emitterNode.position = self.sprite!.position
        emitterNode.name = "FrostboltProjectileParticle"
        emitterNode.zPosition = self.sprite!.zPosition+1
        emitterNode.targetNode = self.sprite!
        self.sprite!.addChild(emitterNode)
        
        self.speed = 125.0
        
        //Setup loop that searches for enemies periodically.
        let waitBlock = SKAction.waitForDuration(searchRate)
        let applyBlock = SKAction.runBlock({
            self.damageSearch(self.sprite!.position)
        })
        let repeatAction = SKAction.repeatActionForever(SKAction.sequence([applyBlock, waitBlock]))
        
        self.sprite!.runAction(repeatAction, withKey: "fireSearch")
        
        Game.global.scene?.addChild(self.sprite!)
        self.launch(endPosition)
    }
    
    //Stop the loop action before removing the projectile.
    override func apply(){
        self.sprite!.removeActionForKey("fireSearch")
        super.apply()
    }
    
    func damageSearch(position: CGPoint) {
        let targets: Array<Unit> = Game.global.getNearbyUnits(position, distance: searchArea, units: potentialTargets)
        //Remove afflicted targets from potential targets (so they dont take damage twice)
        for target in targets {
            removeUnit(target)
            //Deal damage to the target.
            caster.dealDamage(damage, target: target)
            impactEffect(target)
        }
    }
    
    /*
    * Remove a unit from an array
    */
    func removeUnit(unit: Unit)
    {
        var i: Int = 0
        while (i < potentialTargets.count){
            if (potentialTargets[i] == unit) {
                potentialTargets.removeAtIndex(i)
                return
            }
            i++
        }
        
    }
    
    func impactEffect(affectedUnit: Unit){
        let duration = NSTimeInterval(6.0)
        
        affectedUnit.applyTint("frostbolt", red: 0.5, blue: 2.0, green: 0.65)
        affectedUnit.speed.addModifier("frostbolt", value: 0.5)
        affectedUnit.attackSpeed.addModifier("frostbolt", value: 1.5)
        
        let waitAction: SKAction = SKAction.waitForDuration(duration)
        
        let removeBlock: SKAction = SKAction.runBlock({
            affectedUnit.removeTint("frostbolt")
            affectedUnit.speed.removeModifier("frostbolt")
            affectedUnit.attackSpeed.removeModifier("frostbolt")
        })
        
        affectedUnit.sprite.runAction(SKAction.sequence([waitAction, removeBlock]))
    }
}