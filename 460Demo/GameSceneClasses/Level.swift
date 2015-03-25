//
//  Level.swift
//  460Demo
//
//  Created by Olyver on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Level
{
    var title: String = "UNTITLED"
    
    required init() {
        
    }
    
    var counter = 0
    
    func loadWave(scene: GameScene)-> Array<Unit>
    {
        fatalError("Must override loadWave() for level")
    }
}