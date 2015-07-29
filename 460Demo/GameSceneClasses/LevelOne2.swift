//
//  LevelOne2.swift
//  460Demo
//
//  Created by Olyver on 3/25/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//
import SpriteKit

@objc(LevelOne2)
class LevelOne2:Level
{
    required init() {
        super.init()
        title = "Rolling Hills (Two Players)"
        background = "field background"
        self.players = 2
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
            
            //DUMMY_ID = "ENEMY6"
            //dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
            //let dummy6 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            wave.append(dummy2)
            wave.append(dummy3)
        } else if self.counter == 3 {
            //wave 3. 2 Warriors/1 Mage
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy4 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy5 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            let dummy6 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            wave.append(dummy4)
            wave.append(dummy5)
            wave.append(dummy6)
        }
        else if self.counter == 4 {
            //wave 4. 1 Warriors/1 Mage/1 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy9 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            //needs to be priest
            let dummy10 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            //needs to be priest
            let dummy11 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            wave.append(dummy9)
            wave.append(dummy10)
            wave.append(dummy11)
        }
        else if self.counter == 5 {
            //wave 5. 2 Warriors/1 Mage/1 Priest
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
            let dummy12 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
            let dummy13 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-125);
            let dummy14 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
            // needs to be a priest
            
            DUMMY_ID = Game.global.getNextEnemyID()
            dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-125);
            let dummy15 = EnemyPriest(ID: DUMMY_ID, spawnLocation: dummy_position)
            
            wave.append(dummy12)
            wave.append(dummy13)
            wave.append(dummy14)
            wave.append(dummy15)
        }
        return wave
        
    }
}