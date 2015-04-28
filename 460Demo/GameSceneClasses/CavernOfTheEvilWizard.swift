//
//  LevelThree3.swift
//  460Demo
//
//  Created by Olyver on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//


import SpriteKit
@objc(CavernOfTheEvilWizard)
class CavernOfTheEvilWizard:Level
{
    required init() {
        super.init()
        title = "Cavern of The Evil Wizard (Boss)"
        background = "ice background"
    }
    
    override func loadWave(scene: GameScene) -> Array<Unit> {
        var DUMMY_ID: String
        var dummy_position: CGPoint
        var wave: Array<Unit> = []
        self.counter++
        
        if self.counter == 1 {
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
            let dummy1 = EliteMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy1)
        }
        return wave
        
    }
}