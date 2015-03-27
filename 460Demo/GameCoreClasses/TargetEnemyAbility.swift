//
//  TargetEnemyAbility.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class TargetEnemyAbility: TargetedAbility {
    
    override init(imageNamed: String, slot: Int){
        super.init(imageNamed: imageNamed, slot: slot)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func requestTarget(){
        //PUT UP SIGN TO SELECT A TARGET ENEMY UNIT
        super.requestTarget()
    }
    
    override func giveTarget(touch: CGPoint){
        
        if(true) //touched an enemy
        {
            //Successful touch enemy unit
            //var touchedEnemy: Unit
            //apply(Game.global.getMyPlayer()!, target:touchedEnemy)//Get touched unit
            //Game.global.scene?.targetingAbility = nil
        } else {
            //cancle the request target
            Game.global.scene?.targetingAbility = nil
        }
        
        //TAKE DOWN SIGN TO SELECT A TARGET ENEMY UNIT
    }
    
    func apply(user: Unit, target: Unit){
        cooldown(user)
        //OVERRIDE
    }
}