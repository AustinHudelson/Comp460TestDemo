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
    
    /*
     * Default action handeler for this button being pressed.
     * should be overwritten by subclasses
     */
    func apply(user: Unit){
        user.sendOrder(Idle(receiverIn: user))
    }
    
    /*
     * Required initializer to implement SKSpriteNode
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}