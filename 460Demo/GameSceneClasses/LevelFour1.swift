//
//  LevelOne1.swift
//  460Demo
//
//  Created by Olyver on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

//
//  LevelOne.swift
//  460Demo
//
//  Created by Olyver on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
@objc(LevelFour1)
class LevelFour1:Level
{
    required init() {
        super.init()
        title = "Lost Desert (Solo)"
        background = "desert background"
    }
    
    override func loadWave(scene: GameScene) -> Array<Unit> {
        var DUMMY_ID: String
        var dummy_position: CGPoint
        var wave: Array<Unit> = []
        self.counter++
        
        if self.counter == 1 {
            //wave 1. A single Warrior.
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+100);
            let dummy1 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy1)
        } else if self.counter == 2 {
            //wave 2. 2 Warrior
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            let dummy2 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
            let dummy3 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy2)
            wave.append(dummy3)
            
        } else if self.counter == 3 {
            //wave 3. 1 Warriors/1 Mage
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy4 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy5 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy4)
            wave.append(dummy5)
        }
        else if self.counter == 4 {
            //wave 4. 1 Warriors/1 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy6 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            //needs to be priest
            let dummy7 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy6)
            wave.append(dummy7)
        }
        else if self.counter == 5 {
            //wave 5. 1 Warriors/1 Mage/1 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy8 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy9 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            // needs to be a priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            let dummy10 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy8)
            wave.append(dummy9)
            wave.append(dummy10)
        }
        return wave
        
    }
}
