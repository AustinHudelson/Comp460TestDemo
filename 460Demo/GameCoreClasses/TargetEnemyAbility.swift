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
    
    var chooseText: SKLabelNode =  SKLabelNode(text: "Choose an enemy")

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
       
        chooseText.fontSize = 50
        chooseText.fontName = "AvenirNext-Bold"
        chooseText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        chooseText.zPosition = Game.global.UIMinZ
        
        Game.global.scene!.addChild(chooseText)
        
        super.requestTarget()
    }
    
    override func giveTarget(touch: CGPoint){
        var unitTouched = false;
        var touchedUnitID: String = ""
        
        for (name, unit) in Game.global.enemyMap
        {
            //Attack target conditions go here
            /* you touched the sprite, The target is not you, and the target is an enemy. */
            if(unit.sprite.containsPoint(touch) && (unit.isEnemy == true))
            {
                unitTouched = true;
                touchedUnitID = unit.ID
                break
            }
        }
        
        if(unitTouched) //touched an enemy
        {
            
            //Successful touch enemy unit
            var touchedEnemy: Unit = Game.global.getUnit(touchedUnitID)!
            apply(Game.global.getMyPlayer()!, target:touchedEnemy)//Get touched unit
            Game.global.scene?.targetingAbility = nil
        } else {
            //cancle the request target
            
            Game.global.scene?.targetingAbility = nil
        }
        
        //TAKE DOWN SIGN TO SELECT A TARGET ENEMY UNIT
        chooseText.removeFromParent()
    }
    
    func apply(user: Unit, target: Unit){
        cooldown(user)
        //OVERRIDE
    }
}