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
        //wave 1
        let DUMMY_ID1 = "ENEMY1"
        let dummy_position1 = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+10);
        let dummy1 = Enemy(ID: DUMMY_ID1, spawnLocation: dummy_position1)
        
        let DUMMY_ID2 = "ENEMY2"
        let dummy_position2 = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
        let dummy2 = Enemy(ID: DUMMY_ID2, spawnLocation: dummy_position2)
        
        let DUMMY_ID3 = "ENEMY3"
        let dummy_position3 = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-10);
        let dummy3 = Enemy(ID: DUMMY_ID3, spawnLocation: dummy_position3)
        
        enemyWaves[0].append(dummy1)
        enemyWaves[0].append(dummy2)
        enemyWaves[0].append(dummy3)
        
        
        //wave 2
        let DUMMY_ID4 = "ENEMY4"
        let dummy_position4 = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)+10);
        let dummy4 = Enemy(ID: DUMMY_ID1, spawnLocation: dummy_position4)
    
        let DUMMY_ID5 = "ENEMY5"
        let dummy_position5 = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame));
        let dummy5 = Enemy(ID: DUMMY_ID2, spawnLocation: dummy_position5)
        
        let DUMMY_ID6 = "ENEMY6"
        let dummy_position6 = CGPoint(x:CGRectGetMaxX(scene.frame)+50, y:CGRectGetMidY(scene.frame)-10);
        let dummy6 = Enemy(ID: DUMMY_ID3, spawnLocation: dummy_position6)
        enemyWaves[1].append(dummy4)
        enemyWaves[1].append(dummy5)
        enemyWaves[1].append(dummy6)
        
    }
    
    func loadWave()-> Array<Enemy>?
    {
        if counter < enemyWaves.count
        {
            return enemyWaves[counter++]
        }
        return nil
    }
}
