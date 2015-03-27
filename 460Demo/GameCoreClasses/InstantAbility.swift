//
//  InstantAbility.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
class InstantAbility: Ability {
    
    override init(imageNamed: String, slot: Int){
        super.init(imageNamed: imageNamed, slot: slot)
    }
    
    override func buttonPressed(user: Unit){
        apply(user)
    }
    
    func apply(user: Unit){
        cooldown(user)
    }

    
    /*
     * Required initializer to implement SKSpriteNode
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}