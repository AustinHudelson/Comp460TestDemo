//
//  LevelOne.swift
//  460Demo
//
//  Created by Olyver on 3/11/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class LevelOne:Level
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
        
        
        //wave 2. 1 Warrior 1 Mage.
        DUMMY_ID = "ENEMY4"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-200);
        let dummy4 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY5"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame));
        let dummy5 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        //DUMMY_ID = "ENEMY6"
        //dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-100);
        //let dummy6 = EnemyMage(ID: DUMMY_ID, spawnLocation: dummy_position)
        enemyWaves.append(Array<Unit>())
        enemyWaves[1].append(dummy4)
        enemyWaves[1].append(dummy5)
        //enemyWaves[1].append(dummy6)
        
        
        //wave 3. 2 Warriors.
        DUMMY_ID = "ENEMY7"
        dummy_position = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+200);
        let dummy7 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        DUMMY_ID = "ENEMY8"
        dummy_position = CGPoint(x:CGRectGetMinX(scene.frame)-50, y:CGRectGetMidY(scene.frame)+125);
        let dummy8 = Enemy(ID: DUMMY_ID, spawnLocation: dummy_position)
        
        enemyWaves.append(Array<Unit>())
        enemyWaves[2].append(dummy7)
        enemyWaves[2].append(dummy8)
    }
    
    
}
