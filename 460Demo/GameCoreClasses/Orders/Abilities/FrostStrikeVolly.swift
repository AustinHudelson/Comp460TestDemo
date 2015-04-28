//
//  Blink.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

@objc(FrostStrikeVolly)
class FrostStrikeVolly: Order, PType
{
    let DS_destA = CGPoint(x: Game.global.scene!.frame.minX+80.0, y: Game.global.scene!.frame.maxY-200.0)
    let DS_destB = CGPoint(x: Game.global.scene!.frame.maxX-80.0, y: Game.global.scene!.frame.midY)
    let DS_destC = CGPoint(x: Game.global.scene!.frame.minX-80.0, y: Game.global.scene!.frame.minY+100.0)
    let DS_destD = CGPoint(x: Game.global.scene!.frame.midX, y: Game.global.scene!.frame.midY)
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "FrostStrikeVolly"
    }
    
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(FrostStrikeVolly.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
    }
    
    override func apply()
    {
        //Immediate return on invalid caster.
        if DS_receiver == nil || !DS_receiver!.alive{
            return
        }
        DS_receiver!.damageMultiplier.addModifier("frostvolly", value: 0.0)
        
        let blinkSoundAction = SKAction.playSoundFileNamed("teleport.wav", waitForCompletion: true)
        self.DS_receiver!.sprite.runAction(self.DS_receiver!.DS_abilityAnim!)
        let blockCommands: SKAction = SKAction.runBlock({
            self.DS_receiver!.makeUncommandable()
        })
        let unblockCommands: SKAction = SKAction.runBlock({
            self.DS_receiver!.makeCommandable()
        })
        let fadeOut: SKAction = SKAction.fadeAlphaTo(0.2, duration: NSTimeInterval(0.05))
        let fadeIn: SKAction = SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(0.05))
        let moveAAction: SKAction = SKAction.moveTo(DS_destA, duration: NSTimeInterval(0.5))
        let moveBAction: SKAction = SKAction.moveTo(DS_destB, duration: NSTimeInterval(0.5))
        let moveCAction: SKAction = SKAction.moveTo(DS_destC, duration: NSTimeInterval(0.5))
        let moveDAction: SKAction = SKAction.moveTo(DS_destD, duration: NSTimeInterval(0.5))
        
        let startBlink: SKAction = SKAction.group([blinkSoundAction, self.DS_receiver!.DS_abilityAnim!, fadeOut])
        
        let finalBlinkAAction = SKAction.sequence([startBlink, moveAAction, fadeIn])
        let finalBlinkBAction = SKAction.sequence([startBlink, moveBAction, fadeIn])
        let finalBlinkCAction = SKAction.sequence([startBlink, moveCAction, fadeIn])
        let finalBlinkDAction = SKAction.sequence([startBlink, moveDAction, fadeIn])
        
        
        let frostSoundAction = SKAction.playSoundFileNamed("freeze.wav", waitForCompletion: true)
        let launchFrostStrikeAction = SKAction.runBlock({
            let froststrike: Projectile = FroststrikeProjectile(caster: self.DS_receiver!)
        })
        
        let frostStrikeAction = SKAction.group([frostSoundAction, self.DS_receiver!.DS_abilityAnim!, launchFrostStrikeAction])
        
        let faceLeftAction = SKAction.runBlock({
            self.DS_receiver!.faceLeft()
        })
        let faceRightAction = SKAction.runBlock({
            self.DS_receiver!.faceRight()
        })
        let delayAction = SKAction.waitForDuration(NSTimeInterval(0.35))
        let removeInvulAction = SKAction.runBlock({
            self.DS_receiver!.damageMultiplier.removeModifier("frostvolly")
        })
        let restoreRoamAttackAction = SKAction.runBlock({
            self.DS_receiver!.sendOrder(RoamAttack(receiverIn: self.DS_receiver!))
        })
        
        
        let FinalA:SKAction = SKAction.sequence([blockCommands, finalBlinkAAction, faceRightAction, delayAction, faceRightAction, frostStrikeAction, delayAction])
        let FinalB:SKAction = SKAction.sequence([finalBlinkBAction, faceLeftAction, delayAction, faceLeftAction, frostStrikeAction, delayAction])
        let FinalC:SKAction = SKAction.sequence([finalBlinkCAction, faceRightAction, delayAction, faceRightAction, frostStrikeAction, delayAction])
        let FinalD:SKAction = SKAction.sequence([finalBlinkDAction, removeInvulAction, unblockCommands, restoreRoamAttackAction])
        let FinalFinal = SKAction.sequence([FinalA, FinalB, FinalC, FinalD])
        
        self.DS_receiver!.sprite.runAction(FinalFinal)
    }
    
    override func remove() {
        
    }
    
    
}