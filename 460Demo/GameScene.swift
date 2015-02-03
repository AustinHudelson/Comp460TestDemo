//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let war = Warrior()
    //var localSprite = war.sprite
    
    //var localSprite = SKSpriteNode(imageNamed:"Spaceship")
    var Players: [String:Unit] = [:]
    
    //var PlayerSprites: [String:SKSpriteNode] = [:]
    //let PlayerSpeed = CGFloat(100.0)
    var objectTouched = false;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        AppWarpHelper.sharedInstance.gameScene = self
        println("Game Scene Init")
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        //self.addChild(myLabel)
        war.sprite.xScale = 0.5
        war.sprite.yScale = 0.5
        war.sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(war.sprite)
        //PlayerSprites[AppWarpHelper.sharedInstance.playerName] = war.sprite
        Players[AppWarpHelper.sharedInstance.playerName] = war
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
                        var loc2 = touch.locationInNode(self)
            
                        var dist = pow(pow(war.sprite.position.x - loc2.x,2)+pow(war.sprite.position.y - loc2.y,2),0.5)
                        if dist < 175
                        {
                            objectTouched = true
                        }
            
                        
                        //sprite1.position = location
                    }
        
       
    }
    override func touchesEnded(touches:NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            if(objectTouched == true)
            {
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
            //var playerPosition:String = NSStringFromCGPoint(location)
                //Add the string to the dictionary
            //dataDict.setObject(playerPosition, forKey: "playerPosition")
                //dataDict.setObject(NSValue(CGPoint: player!.position), forKey: "playerPosition")
                
                var move = Move(position1: location)
                //println(move);
                dataDict.setObject(move.description, forKey: "order")
                
                
                //Notify Room of updated data
                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
                objectTouched = false
            }
            else
            {
                
            }
            
        }
    }

    
    func updateEnemyStatus(dataDict: NSDictionary){
        println("Running Update Status")
        //println(dataDict.objectForKey("order")as String)
        //println(war.sprite.position)
        var receivedOrder = Move(positionString: (dataDict.objectForKey("order")as String))
        //println(receivedOrder.position)
        
        //var touchLocStr = dataDict.objectForKey("playerPosition") as String
        //var touchLoc = CGPointFromString(touchLocStr)
        
        if let unit = Players[dataDict.objectForKey("userName") as String]
        {
            //println("here")
            unit.apply(receivedOrder)
        }
        else
        {
            let newWarrior = Warrior()
            newWarrior.sprite.xScale = 0.3
            newWarrior.sprite.yScale = 0.3
            newWarrior.sprite.position = receivedOrder.position
            self.addChild(newWarrior.sprite)
            Players[dataDict.objectForKey("userName") as String] = newWarrior
        }
        //if let sprite = PlayerSprites[dataDict.objectForKey("userName") as String] {
            
//            let charPos = sprite.position;
//            //localSprite.position = sprite.position
//            let xdif = touchLoc.x-charPos.x
//            let ydif = touchLoc.y-charPos.y
//            
//            let distance = sqrt((xdif*xdif)+(ydif*ydif))
//            let duration = distance/war.speed//PlayerSpeed
//            let action = SKAction.moveTo(touchLoc, duration:NSTimeInterval(duration))
//            //sprite.runAction(action)
//            sprite.runAction(action)
            
       // }
//        else {
//            //This is a new user that has not been seen before
//            //Create a new sprite for this user
//            let newSprite = SKSpriteNode(imageNamed:"Spaceship")
//            newSprite.xScale = 0.3
//            newSprite.yScale = 0.3
//            newSprite.position = touchLoc
//            self.addChild(newSprite)
//            PlayerSprites[dataDict.objectForKey("userName") as String] = newSprite
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
