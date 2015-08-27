//
//  LevelThree1.swift
//  460Demo
//
//  Created by Olyver on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(LevelFive2)
class LevelFive2:Level
{
    required init() {
        super.init()
        title = "Cavern of The Evil Wizard (Boss)"
        background = "ice background"
        players = 2
    }
    
    override func loadWave(scene: GameScene) -> Array<Unit> {
        var DUMMY_ID: String
        var dummy_position: CGPoint
        var wave: Array<Unit> = []
        self.counter++
        
        if self.counter == 2 {
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
            let dummy7 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            let dummy8 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy9 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy7)
            wave.append(dummy8)
            wave.append(dummy9)
        }
        if self.counter == 1 {
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
            let dummy4 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-75);
            let dummy5 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+75);
            let dummy6 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy4)
            wave.append(dummy5)
            wave.append(dummy6)
        }
        if self.counter == 3 {
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
            let dummy1 = EliteMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            let dummy2 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy3 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy1)
            wave.append(dummy2)
            wave.append(dummy3)
        }
        return wave
        
    }
}
