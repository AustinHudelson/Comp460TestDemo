//
//  LevelTwo1.swift
//  460Demo
//
//  Created by Olyver on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(LevelTwo1)
class LevelTwo1:Level
{
    
    required init() {
        super.init()
        title = "The Ice Caves (Solo)"
        background = "ice background"
        players = 1
    }
    
    override func loadWave(scene: GameScene) -> Array<Unit> {
        var DUMMY_ID: String
        var dummy_position: CGPoint
        var wave: Array<Unit> = []
        self.counter++
        
        if self.counter == 1 {
            //wave 1. 3 Warrior.
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy1 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+200);
            let dummy2 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-200);
            let dummy3 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy1)
            wave.append(dummy2)
            wave.append(dummy3)
        } else if self.counter == 2 {
            //wave 2. 3 Warrior / 1 Mage
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            let dummy5 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            let dummy6 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy4 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+125);
            let dummy7 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            wave.append(dummy4)
            wave.append(dummy5)
            wave.append(dummy6)
            wave.append(dummy7)
            
        } else if self.counter == 3 {
            //wave 3.2 Warrior/1 Mage/1 priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy10 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy11 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            let dummy8 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            //should be priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-125);
            let dummy9 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            
            wave.append(dummy10)
            wave.append(dummy11)
            wave.append(dummy8)
            wave.append(dummy9)
        }
        else if self.counter == 4 {
            //wave 4. 3 Warriors/2 Mage
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy14 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            
            let dummy15 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
            
            let dummy12 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            
            let dummy16 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            
            let dummy13 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy13)
            wave.append(dummy14)
            wave.append(dummy15)
            wave.append(dummy12)
            wave.append(dummy16)
            
        }
            
        else if self.counter == 5 {
            //wave 5. 2 Warrior/2 Mage/ 1 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy14 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            let dummy15 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
            let dummy16 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+200);
            let dummy17 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            //should be priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-200);
            let dummy18 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy14)
            wave.append(dummy15)
            wave.append(dummy16)
            wave.append(dummy17)
            wave.append(dummy18)
        }
        return wave
        
    }
}