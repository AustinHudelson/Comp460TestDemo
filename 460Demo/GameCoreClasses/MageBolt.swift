//
//  MageBolt.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/23/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class MageBolt: Projectile {
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
        
        let emitterPath: String = NSBundle.mainBundle().pathForResource("MagicBolt", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as SKEmitterNode
        //emitterNode.position = self.sprite!.position
        emitterNode.name = "MagicBolt"
        emitterNode.zPosition = self.sprite!.zPosition+1
        emitterNode.targetNode = self.sprite!
        self.sprite!.addChild(emitterNode)
        
        self.speed = 850.0
        
        Game.global.scene?.addChild(self.sprite!)
        self.launch(target.sprite.position)
    }
    
    override func apply(){
        super.apply()
        caster.dealDamage(caster.attackDamage.get(), target: target)
    }
}