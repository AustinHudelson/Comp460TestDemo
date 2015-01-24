//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var PlayerSprites: [String:SKSpriteNode] = [:]
    let PlayerSpeed = CGFloat(100.0)
    
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
            
            //Make a muteable dictionary to send over appwarp
            var dataDict = NSMutableDictionary()
            
            //Store the userName/playerName in the sending dictionary
            //Set the username for the muteable dictionary
            dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "userName")
            
            
            ////Convert the touched location to a string for projectile position
            //var destStr:String = NSStringFromCGPoint(location)
            //dataDict.setObject(destStr, forKey: "projectileDest")
            
            //Convert the player position to a string
            var playerPosition:String = NSStringFromCGPoint(location)
            //Add the string to the dictionary
            dataDict.setObject(playerPosition, forKey: "playerPosition")
            //dataDict.setObject(NSValue(CGPoint: player!.position), forKey: "playerPosition")
            
            //Notify Room of updated data
            AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
        }
    }
    
    func updateEnemyStatus(dataDict: NSDictionary){
        println("Running Update Status")
        
        //Get the touched location from the recieved dictionary
        var touchLocStr = dataDict.objectForKey("playerPosition") as String
        var touchLoc = CGPointFromString(touchLocStr)
        
        //Check the local sprite dictionary if it has a sprite for the user name stored in the recieved dictionary
        if let sprite = PlayerSprites[dataDict.objectForKey("userName") as String] {
            let charPos = sprite.position;
            let xdif = touchLoc.x-charPos.x
            let ydif = touchLoc.y-charPos.y
            //Calculate distance
            let distance = sqrt((xdif*xdif)+(ydif*ydif))
            //Calculate travel time
            let duration = distance/PlayerSpeed
            //Set up a move action "Move to touchLoc over duration"
            let action = SKAction.moveTo(touchLoc, duration:NSTimeInterval(duration))
            sprite.runAction(action)
        } else {
            //This is a new user that has not been seen before
            //Create a new sprite for this user
            let newSprite = SKSpriteNode(imageNamed:"Spaceship")
            newSprite.xScale = 0.3
            newSprite.yScale = 0.3
            //Spawn the sprite at the first touch location
            newSprite.position = touchLoc
            //Add the sprite to the scene (so we can see it)
            self.addChild(newSprite)
            //Add the sprite to the local Sprite Dictionary
            PlayerSprites[dataDict.objectForKey("userName") as String] = newSprite
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
