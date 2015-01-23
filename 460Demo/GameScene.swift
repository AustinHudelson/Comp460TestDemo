//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        AppWarpHelper.sharedInstance.gameScene = self
        println("Game Scene Init")
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
            
            //Make a muteable dictionary to send over appwarp
            var dataDict = NSMutableDictionary()
            //Set the username for the muteable dictionary
            dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "userName")
            
            
            //dataDict.setObject(NSValue(CGPoint: destination), forKey: "projectileDest")
            
            
            ////Convert the touched location to a string for projectile position
            //var destStr:String = NSStringFromCGPoint(location)
            //dataDict.setObject(destStr, forKey: "projectileDest")
            
            //Convert the player position to a string
            var playerPosition:String = NSStringFromCGPoint(location)
            //Add the string to the dictionary
            dataDict.setObject(playerPosition, forKey: "playerPosition")
            //dataDict.setObject(NSValue(CGPoint: player!.position), forKey: "playerPosition")
            
            
            //dataDict.setObject(String(realTimeDuration), forKey: "realMoveDuration")
            ////dataDict.setObject(NSValue(nonretainedObject: realTimeDuration), forKey: "realMoveDuration")
            
            //Send the update message
            AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
        }
    }
    
    func updateEnemyStatus(dataDict: NSDictionary)
    {
        println("updateEnemyStatus...1")
        
        //playerPositon
        let count = dataDict.count
        //if count < 2
        //{
        //    return
        //}
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        //Ship spawned by other player should be slightly smaller
        sprite.xScale = 0.3
        sprite.yScale = 0.3
        
        //get the sprite's spawn location
        var spawnLocStr = dataDict.objectForKey("playerPosition") as String
        var spawnLoc = CGPointFromString(spawnLocStr)
        sprite.position = spawnLoc
        self.addChild(sprite)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
