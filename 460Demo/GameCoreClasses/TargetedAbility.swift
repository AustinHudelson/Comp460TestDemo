//
//  TargetedAbility.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class TargetedAbility: Ability {
    
    override init(imageNamed: String, slot: Int){
        super.init(imageNamed: imageNamed, slot: slot)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func buttonPressed(user: Unit){
        requestTarget()
    }
    
    func requestTarget(){
        if Game.global.scene == nil {
            return
        }
        Game.global.scene!.targetingAbility = self
    }
    
    func giveTarget(touch: CGPoint){
        //MUST OVERRIDE
    }
}