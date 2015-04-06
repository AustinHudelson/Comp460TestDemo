//
//  Ability.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit
class Ability: SKSpriteNode
{
    /* Constants for the size and placement of the buttons. (still not 100% correct) */
    let buttonSize: CGSize = CGSize(width: 64, height: 64)
    let topLeftSpacing: CGFloat = 64
    let abilitySpacing: CGFloat = 25.0
    
    var cooldown: NSTimeInterval = 10.0
    var cooldownReady: Bool = true
    var tooltip: String = "MISSING TOOLTIP"
    
    /*
     * Builds the button and ACTUALLY PLACES IT IN THE GAME SCENE.
     * calculates the position based on the slot parameter.
     * slot should be an index starting at 0.
     */
    init(imageNamed: String, slot: Int) {
        // super.init(imageNamed:"bubble") You can't do this because you are not calling a designated initializer.
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.whiteColor(), size: buttonSize)
        
        let position: CGPoint = CGPoint(x: CGFloat((topLeftSpacing)+(CGFloat(slot)*(abilitySpacing+buttonSize.width))), y: topLeftSpacing)
        self.position = position
        self.name="Ability\(slot)"
        self.zPosition = 100
        
        Game.global.scene!.addChild(self)
        self.hidden = false
    }
    
    func buttonPressed(user: Unit){
        //SHOULD BE OVERRIDDEN
    }
    
    /*
     * Default action handeler for this button being pressed.
     * should be overwritten by subclasses. Triggers ability cooldown.
     */
    func cooldown(user: Unit){
        cooldownReady = false
        let delay = SKAction.waitForDuration(cooldown)
        let shrink = SKAction.scaleTo(0.8, duration:NSTimeInterval(0.5))
        let oversizeGrow = SKAction.scaleTo(2.0, duration:NSTimeInterval(0.25))
        let restoreSize = SKAction.scaleTo(1.0, duration:NSTimeInterval(0.35))
        let fadeTint = SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 0.5, duration: NSTimeInterval(0.5))
        let unfadeTint = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: NSTimeInterval(0.25))
        let flagCooldownComplete = SKAction.runBlock({self.cooldownReady = true})
        //action to shrink and fade the cooldowns tint
        let cooldownStart = SKAction.group([shrink, fadeTint])
        //Action to Grow the button oversize, restore the tint, then restore the size. to create a pulse effect.
        let cooldownEnd = SKAction.sequence([flagCooldownComplete, SKAction.group([oversizeGrow, unfadeTint]), restoreSize])
        //Final action. Start the delay at the same time as the cooldown start animation as to not delay the duration of the cooldown. Cooldown end will run after the cooldown delay, so this action will take ~1 second longer than the actual cooldown duration, but the button will flash after the correct duration.
        let finalSequence = SKAction.sequence([SKAction.group([cooldownStart, delay]), cooldownEnd])
        
        self.runAction(finalSequence, withKey: "cooldown")
    }
    
    /*
     * Required initializer to implement SKSpriteNode
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}