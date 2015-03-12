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
    let buttonSize: CGSize = CGSize(width: 100, height: 100)
    let topLeftSpacing: CGFloat = 10.0
    let abilitySpacing: CGFloat = 25.0
    
    init(imageNamed: String, slot: Int) {
        // super.init(imageNamed:"bubble") You can't do this because you are not calling a designated initializer.
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: buttonSize)
        
        let position: CGPoint = CGPoint(x: CGFloat((topLeftSpacing)+(CGFloat(slot)*(abilitySpacing+buttonSize.width))), y: topLeftSpacing)
        Game.global.scene!.addChild(self)
        self.hidden = false
    }
    
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