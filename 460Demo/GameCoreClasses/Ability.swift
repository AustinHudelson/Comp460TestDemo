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
    
    init(imageNamed: String, slot: Int) {
        // super.init(imageNamed:"bubble") You can't do this because you are not calling a designated initializer.
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: buttonSize)
        self.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}