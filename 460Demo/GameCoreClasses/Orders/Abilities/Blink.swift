//
//  Blink.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(Blink)
class Blink: Order, PType
{
    var destX: CGFloat = 0.0
    var destY: CGFloat = 0.0
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Blink"
        
        let minX: CGFloat = Game.global.scene!.frame.minX+50.0
        let maxX: CGFloat = Game.global.scene!.frame.maxX-50.0
        let minY: CGFloat = Game.global.scene!.frame.minY+50.0
        let maxY: CGFloat = Game.global.scene!.frame.maxY-50.0
        destX = CGFloat.random(min: minX, max: maxX)
        destY = CGFloat.random(min: minY, max: maxY)
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Blink.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        //let soundAction = SKAction.playSoundFileNamed("ogre3.wav", waitForCompletion: true)
        //self.DS_receiver?.sprite.runAction(soundAction)
        //let applyAction: SKAction = SKAction.runBlock(applyBuff)
        //let waitAction: SKAction = SKAction.waitForDuration(0.5)
        //let removeAction: SKAction = SKAction.runBlock(removeBuff)
        //let applySeq: SKAction = SKAction.sequence([applyAction, waitAction, removeAction])
        //self.DS_receiver?.sprite.runAction(applySeq)
        
        //Immediate return on invalid caster.
        if DS_receiver == nil || !DS_receiver!.alive{
            return
        }
        let blockCommands: SKAction = SKAction.runBlock({
            self.DS_receiver!.makeUncommandable()
        })
        let unblockCommands: SKAction = SKAction.runBlock({
            self.DS_receiver!.makeCommandable()
        })
        let fadeOut: SKAction = SKAction.fadeAlphaTo(0.2, duration: NSTimeInterval(0.05))
        let fadeIn: SKAction = SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(0.05))
        let destination = CGPoint(x:destX, y:destY)
        let moveAction: SKAction = SKAction.moveTo(destination, duration: NSTimeInterval(0.5))
        
        let healthDestination = CGPoint(x:destX + self.DS_receiver!.health_bar_x_dspl, y:destY + self.DS_receiver!.health_txt_y_dspl)
        let moveActionHealth: SKAction = SKAction.moveTo(healthDestination, duration: NSTimeInterval(0.5))
        let finalBlinkAction = SKAction.sequence([blockCommands, fadeOut, moveAction, fadeIn, unblockCommands])
        let finalBlinkActionHealth = SKAction.sequence([fadeOut, moveActionHealth, fadeIn ])
        
        self.DS_receiver?.sprite.runAction(finalBlinkAction)
        self.DS_receiver?.DS_health_bar.runAction(finalBlinkActionHealth)
    }
    
    override func remove() {
        
    }
    
    
}