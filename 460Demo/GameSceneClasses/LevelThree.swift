//
//  LevelThree.swift
//  460Demo
//
//  Created by Austin on 3/19/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class LevelThree:Level
{
    
    init(scene: GameScene)
    {
        super.init()
        
        var DUMMY_ID = "ENEMY0"
        var dummy_position: CGPoint
        
        //wave 1. A single Warrior.
        DUMMY_ID = "ENEMY1"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+100);
        let dummy1 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        //DUMMY_ID = "ENEMY2"
        //dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
        //let dummy2 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        //DUMMY_ID = "ENEMY3"
        //dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
        //let dummy3 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        enemyWaves.append(Array<Unit>())
        enemyWaves[0].append(dummy1)
        //enemyWaves[0].append(dummy2)
        //enemyWaves[0].append(dummy3)
        
        
        //wave 2. 2 Warriors.
        DUMMY_ID = "ENEMY4"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
        let dummy4 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY5"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
        let dummy5 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        //DUMMY_ID = "ENEMY6"
        //dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
        //let dummy6 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        enemyWaves.append(Array<Unit>())
        enemyWaves[1].append(dummy4)
        enemyWaves[1].append(dummy5)
        //enemyWaves[1].append(dummy6)
        
        
        //wave 3. 2 Warriors. 1 Mage.
        DUMMY_ID = "ENEMY7"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
        let dummy7 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY8"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
        let dummy8 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY9"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
        let dummy9 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        enemyWaves.append(Array<Unit>())
        enemyWaves[2].append(dummy7)
        enemyWaves[2].append(dummy8)
        enemyWaves[2].append(dummy9)
        
        //wave 4. 1 Warriors. 2 Mage.
        DUMMY_ID = "ENEMY10"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
        let dummy10 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY11"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-50);
        let dummy11 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY12"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
        let dummy12 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        enemyWaves.append(Array<Unit>())
        enemyWaves[3].append(dummy10)
        enemyWaves[3].append(dummy11)
        enemyWaves[3].append(dummy12)
        
        //wave 5. 2 Warriors. 2 Mage.
        DUMMY_ID = "ENEMY13"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+155);
        let dummy13 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY14"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)-120);
        let dummy14 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY15"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+100);
        let dummy15 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY16"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
        let dummy16 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        enemyWaves.append(Array<Unit>())
        enemyWaves[4].append(dummy13)
        enemyWaves[4].append(dummy14)
        enemyWaves[4].append(dummy15)
        enemyWaves[4].append(dummy16)
    }
    
    
}
