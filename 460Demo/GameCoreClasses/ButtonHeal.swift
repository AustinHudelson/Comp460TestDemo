//
//  File.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonHeal: Ability
{
    
    /*
     * Creates a heal icon at the specified ability use slot
     */
    init(slot: Int){
        super.init(imageNamed: "S_Buff03", slot: slot)
    }
    
    override func apply(receiverIn: Unit) {
        receiverIn.takeDamage(-20)
    }
    
    /*
    * Required initializer to implement SKSpriteNode
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}