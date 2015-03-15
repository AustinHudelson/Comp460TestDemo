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
    
    var enemyWaves: Array<Array<Unit>> = Array<Array<Unit>>()
    var counter = 0
    
    
    func loadWave()-> Array<Unit>?
    {
        if counter < enemyWaves.count
        {
            return enemyWaves[counter++]
        }
        return nil
    }
    
    func hasMoreWaves()->Bool
    {
        return counter<enemyWaves.count
    }
    
}