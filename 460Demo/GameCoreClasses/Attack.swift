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
    override init(sender: Unit, receiver: Unit)
    {
        super.init(sender: sender, receiver: receiver)
    }
    func apply()
    {
        println("MOVING")
        let charPos = self.sender.sprite.position
        //println(charPos)
        let xdif = self.receiver.sprite.position.x-charPos.x
        let ydif = self.receiver.sprite.position.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/self.sender.speed
        let movementAction = SKAction.moveTo(self.receiver.sprite.position, duration:NSTimeInterval(duration))
        let walkAnimationAction = self.sender.walkAnim
        //let action = SKAction.group([SKAction., movementAction])
        
        
        //sprite.runAction(action)
        //sprite.removeActionForKey("position")
        //sprite.removeActionForKey("stand")
        self.sender.sprite.removeAllActions()
        self.sender.health_txt.removeAllActions()
        self.sender.sprite.runAction(walkAnimationAction, withKey: "position")
        self.sender.sprite.runAction(movementAction, completion: {
            
            self.receiver.takeDamage(1)
            self.sender.sprite.runAction(self.sender.attackAnim, withKey: "attack")
        })
        
        //self.sprite.runAction(movementAction)
        //sprite.runAction(self.walkAnim)
        
        /* Move the health text */
        var health_txt_des = self.receiver.sprite.position
        health_txt_des.y += self.sender.health_txt_y_dspl
        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
        self.sender.health_txt.runAction(moveHealthTxtAction)    }
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
