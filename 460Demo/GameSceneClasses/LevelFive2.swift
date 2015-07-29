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
        title = "The Dark Dungon (Two Players)"
        background = "Dungon Background"
        self.players = 2
    }
    
    override func loadWave(scene: GameScene) -> Array<Unit> {
        var DUMMY_ID: String
        var dummy_position: CGPoint
        var wave: Array<Unit> = []
        self.counter++
        
        if self.counter == 1 {
            //wave 1.1 Warrior/1Mage
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+100);
            let dummy1 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy1)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+100);
            let dummy2 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy1)
            wave.append(dummy2)
        } else if self.counter == 2 {
            //wave 2. 1 Warrio/ 1 Mage/1 Priest
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
            let dummy3 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
            let dummy4 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame), y:CGRectGetMidY(scene.frame)+125);
            let dummy5 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            //DUMMY_ID = "ENEMY6"
            //dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
            //let dummy6 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            wave.append(dummy3)
            wave.append(dummy4)
            wave.append(dummy5)
        } else if self.counter == 3 {
            //wave 3. 2 Mage/1 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy6 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy7 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            //needs to be a priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-200);
            let dummy8 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy6)
            wave.append(dummy7)
            wave.append(dummy8)
        }
        else if self.counter == 4 {
            //wave 4. 1 Mage/2 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy7 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            
            let dummy8 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-125);
            
            let dummy9 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy7)
            wave.append(dummy8)
            wave.append(dummy9)
        }
        else if self.counter == 5 {
            //wave 5. 1 Boss/1 Warrior
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy10 = EnemyBoss(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy11 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            
            
            wave.append(dummy10)
            wave.append(dummy11)
            
        }
        return wave
        
    }
}
