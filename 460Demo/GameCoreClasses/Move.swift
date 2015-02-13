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
    var position: CGPoint
    
    init(sender: Unit, receiver: Unit, position1: CGPoint)
    {
        position = position1
        super.init(sender: sender, receiver: receiver)
    }
    func apply()
    {
        
        println("MOVING")
        let charPos = self.sender.sprite.position
        //println(charPos)
        let xdif = position.x-charPos.x
        let ydif = position.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/self.sender.speed
        let movementAction = SKAction.moveTo(position, duration:NSTimeInterval(duration))
        let walkAnimationAction = self.sender.walkAnim
        //let action = SKAction.group([SKAction., movementAction])
        
        
        //sprite.runAction(action)
        //sprite.removeActionForKey("position")
        //sprite.removeActionForKey("stand")
        self.sender.sprite.removeAllActions()
        self.sender.health_txt.removeAllActions()
        self.sender.sprite.runAction(walkAnimationAction, withKey: "position")
        self.sender.sprite.runAction(movementAction, completion: {
        
        self.sender.sprite.runAction(self.sender.standAnim, withKey: "stand")
        })
        
        //self.sprite.runAction(movementAction)
        //sprite.runAction(self.walkAnim)
        
        /* Move the health text */
        var health_txt_des = position
        health_txt_des.y += self.sender.health_txt_y_dspl
        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
        self.sender.health_txt.runAction(moveHealthTxtAction)
    }
//    init(positionString:String)
//    {
//        //println(positionString)
//        var temp = positionString.stringByReplacingOccurrencesOfString("\\(", withString: "{", options: .RegularExpressionSearch).stringByReplacingOccurrencesOfString("\\)", withString: "}", options: .RegularExpressionSearch) as String
//        //println(temp)
//        position = CGPointFromString(temp)
//    }
//    override var description: String {
//        return "\(position)"
//    }
    
    
    
}