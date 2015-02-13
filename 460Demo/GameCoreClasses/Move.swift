//
//  File.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Move : Order
{
    var moveToLoc: CGPoint
    
    init(sender: Unit, receiver: Unit, moveToLoc: CGPoint)
    {
        self.moveToLoc = moveToLoc
        super.init(sender: sender, receiver: receiver)
    }
    func apply()
    {
        
        println("MOVING")
        let charPos = self.sender.sprite.position
        //println(charPos)
        let xdif = moveToLoc.x-charPos.x
        let ydif = moveToLoc.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/self.sender.speed
        let movementAction = SKAction.moveTo(moveToLoc, duration:NSTimeInterval(duration))
        let walkAnimationAction = self.sender.walkAnim
        //let action = SKAction.group([SKAction., movementAction])
        
        
        //sprite.runAction(action)
        //sprite.removeActionForKey("moveToLoc")
        //sprite.removeActionForKey("stand")
        self.sender.sprite.removeAllActions()
        self.sender.health_txt.removeAllActions()
        self.sender.sprite.runAction(walkAnimationAction, withKey: "moveToLoc")
        self.sender.sprite.runAction(movementAction, completion: {
        
        self.sender.sprite.runAction(self.sender.standAnim, withKey: "stand")
        })
        
        //self.sprite.runAction(movementAction)
        //sprite.runAction(self.walkAnim)
        
        /* Move the health text */
        var health_txt_des = moveToLoc
        health_txt_des.y += self.sender.health_txt_y_dspl
        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
        self.sender.health_txt.runAction(moveHealthTxtAction)
    }
}