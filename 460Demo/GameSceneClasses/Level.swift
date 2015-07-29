//
//  Level.swift
//  460Demo
//
//  Created by Olyver on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(Level)
class Level
{
    var title: String = "UNTITLED"
    var background: String = "Background1"
    var players: Int = 0
    
    required init() {
        title = NSStringFromClass(self.dynamicType) // This basically dynamically gets the class name and convert it into a string (eg, if this obj is an instance of LevelOne1, title = "LevelOne1")
    }
    
    var counter = 0
    
    func loadWave(scene: GameScene)-> Array<Unit>
    {
        fatalError("Must override loadWave() for class Level")
    }
}