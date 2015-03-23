//
//  MageBolt.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/23/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class FrostboltProjectile: Projectile {
    var target: Unit
    var caster: Unit
    
    init(target: Unit, caster: Unit){
        self.target = target
        self.caster = caster
        super.init()
        self.sprite = SKSpriteNode(imageNamed: "Spark")
        
        //Determine start position of the projectile!!
        self.sprite!.position = caster.sprite.position
        self.sprite!.zPosition = caster.sprite.zPosition+1
        
        let emitterPath: String = NSBundle.mainBundle().pathForResource("FrostboltProjectileParticle", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as SKEmitterNode
        //emitterNode.position = self.sprite!.position
        emitterNode.name = "FrostboltProjectileParticle"
        emitterNode.zPosition = self.sprite!.zPosition+1
        emitterNode.targetNode = self.sprite!
        self.sprite!.addChild(emitterNode)
        
        self.speed = 850.0
        
        Game.global.scene?.addChild(self.sprite!)
        self.launch(target.sprite.position)
    }
    
    override func apply(){
        super.apply()
        let targets: Array<Unit> = Game.global.getNearbyEnemies(target.sprite.position, distance: 300)
        for impactTarget in targets {
            impactEffect(impactTarget)
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