//
//  Projectile.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Projectile
{
    //let launchXOffset = 100
    //let launchYOffset = 25
    
    var speed : CGFloat?
    var sprite : SKSpriteNode?
    
    init(){
        
    }
    
    
    /*
    Once the projectile is initialized call launch to have it move to the target position and 
    then call the apply().
    */
    func launch(target: CGPoint){
        if (sprite == nil || speed == nil){
            return;
        }
        
        //Setup Move to target action
        let distance = Game.global.getDistance(sprite!.position, p2: target)
        let time = distance/speed!
        let movement: SKAction = SKAction.moveTo(target, duration: NSTimeInterval(time))
        
        //Setup run apply on complete and delete projectile
        let complete: SKAction = SKAction.runBlock({
            self.apply()
            self.sprite!.removeFromParent()
        })
        
        self.sprite!.runAction(SKAction.sequence([movement, complete]))
    }
    
    func apply(){}
}
