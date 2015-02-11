//
//  Attack.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Attack: Order
{
    /* CHANGE THIS */
    override init(sender: String, receiver: String)
    {
        super.init(sender: sender, receiver: receiver)
    }
    func apply(sender: Unit, receiver: Unit)
    {
        println("MOVING")
        let charPos = sender.sprite.position
        //println(charPos)
        let xdif = receiver.sprite.position.x-charPos.x
        let ydif = receiver.sprite.position.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/sender.speed
        let movementAction = SKAction.moveTo(receiver.sprite.position, duration:NSTimeInterval(duration))
        let walkAnimationAction = sender.walkAnim
        //let action = SKAction.group([SKAction., movementAction])
        
        
        //sprite.runAction(action)
        //sprite.removeActionForKey("position")
        //sprite.removeActionForKey("stand")
        sender.sprite.removeAllActions()
        sender.health_txt.removeAllActions()
        sender.sprite.runAction(walkAnimationAction, withKey: "position")
        sender.sprite.runAction(movementAction, completion: {
            
            receiver.takeDamage(-1)
            sender.sprite.runAction(sender.attackAnim, withKey: "attack")
        })
        
        //self.sprite.runAction(movementAction)
        //sprite.runAction(self.walkAnim)
        
        /* Move the health text */
        var health_txt_des = receiver.sprite.position
        health_txt_des.y += sender.health_txt_y_dspl
        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
        sender.health_txt.runAction(moveHealthTxtAction)    }
//    init(tar:Unit)
//    {
//        target = tar;
//    }
//    init(unit:Unit)
//    {
//        target = unit
//    }
//    override var description: String {
//        return "\(target.name)"
//    }
    
}
