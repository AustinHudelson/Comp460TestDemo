//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit



class GameScene: SKScene {
    
    var unit_list: [Unit] = [] // Our list of units in the scene
    var playerIsTouched = false
    
    /*
        This function creates a unit on the screen & sends this unit over the network to peers
        - It only creates a player of type Warrior right now
    */
    func createUnit(unitName: String) -> Unit {
        return Warrior(name: unitName, health: 100, speed: CGFloat(100.0))
    }
    /*
        Update the game state according to data received over the network
        - Eg. usage of recvData assuming the data sent is the example from sendUpdate():
            let unit_list = recvData["Units"].arrayObject
            // unit_list is now [Unit(player1), Unit(player2), Unit(enemy1), Unit(enemey2)],
    */
    func updateGameState(recvData: JSON) {
        let recv_unit_list = (recvData["Units"].arrayObject! as Array)
        /*
            Check the recieved unit list against our local unit list, if there are any new units, add them
        */
        var new_local_unit_list = unit_list // might be a bug here if Swift doesnt do a deep copy of arrays
        for recv_unit in recv_unit_list {
            for local_unit in unit_list {
                if (local_unit.name != (recv_unit as Unit).name) {
                    // Create this new unit
                    println("hi")
                }
            }
        }
        unit_list = new_local_unit_list
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("Game Scene Init")
        AppWarpHelper.sharedInstance.gameScene = self
        
        // Create a warrior unit with name = player name
        let war = createUnit(AppWarpHelper.sharedInstance.playerName)
        war.sprite.xScale = 0.5
        war.sprite.yScale = 0.5
        war.sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        // Add the warrior to our list of units in the scene
        unit_list.append(war)
        
        // Tell SpriteKit to actually draw the the initially create Units in scene
        for unit in unit_list {
            self.addChild(war.sprite)
        }
        
        // Send the initial units data over appwarp
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Units"] = []
        for unit in unit_list {
            sendData["Units"]!.append(unit.toJSONDict())
        }
        
        // TEST
//        var sendData2: Dictionary<String, Array<AnyObject>> = ["Units": [["health": 100, "name": "aaa", "speed": 100, "unitType": "Warrior"]]]
        var sendData2: Dictionary<String, String> = ["Units": "hi"]
//        AppWarpHelper.sharedInstance.sendUpdate(sendData2)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)

            /*
                Determine if the touch is on your own character's sprite
            */
            for unit in unit_list {
                if unit.name == AppWarpHelper.sharedInstance.playerName {
                    if unit.sprite.containsPoint(touchLocation) {
                        playerIsTouched = true
                    }
                }
            }
        }
    }
    override func touchesEnded(touches:NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            if playerIsTouched == true {
//                let touchLocation = touch.locationInNode(self)
//                //Make a muteable dictionary to send over appwarp
//                    var dataDict = NSMutableDictionary()
//                    
//                    //Store the userName/playerName in the sending dictionary
//                    //Set the username for the muteable dictionary
//                    dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "userName")
//                
//                var touchedUnit = war as Unit
//                var unitTouched = false;
//                for(player,unit) in Players
//                {
//                    if(unit.sprite.containsPoint(location))
//                    {
//                        touchedUnit = unit
//                        unitTouched = true;
//                        break
//                    }
//                }
//                
//                if(unitTouched)
//                {
//                    var attack = Attack(tar: touchedUnit)
//                    dataDict.setObject(attack.description, forKey: "attack")
//                    
//                }
//                else
//                {
//                    
//                    
//                    
//                    ////Convert the touched location to a string for projectile position
//                    //var destStr:String = NSStringFromCGPoint(location)
//                    //dataDict.setObject(destStr, forKey: "projectileDest")
//                    
//                    //Convert the player position to a string
//                //var playerPosition:String = NSStringFromCGPoint(location)
//                    //Add the string to the dictionary
//                //dataDict.setObject(playerPosition, forKey: "playerPosition")
//                    //dataDict.setObject(NSValue(CGPoint: player!.position), forKey: "playerPosition")
//                    
//                    var move = Move(position1: location)
//                    //println(move);
//                    dataDict.setObject(move.description, forKey: "move")
//                    
//                    
//                    //Notify Room of updated data
//                    
//                }
//                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
//                    objectTouched = false
            }
           
            
        }
    }

    
    func updateEnemyStatus(dataDict: NSDictionary){
//        println("Running Update Status")
//        //println(dataDict.objectForKey("order")as String)
//        //println(war.sprite.position)
//        var receivedOrder: Order
//        if(dataDict.objectForKey("move") != nil)
//        {
//           receivedOrder = Move(positionString: (dataDict.objectForKey("move")as String))
//        }
//        else if (dataDict.objectForKey("attack") != nil)
//        {
//            var attackedUnit = war as Unit
//            for(player,unit) in Players
//            {
//                if(unit.name == dataDict.objectForKey("attack") as String)
//                {
//                    attackedUnit = unit
//                    break
//                }
//            }
//            receivedOrder = Attack(unit: attackedUnit)
//        }
//        else
//        {
//            receivedOrder = Move(positionString: (dataDict.objectForKey("move")as String))
//        }
//        
//        //println(receivedOrder.position)
//        
//        //var touchLocStr = dataDict.objectForKey("playerPosition") as String
//        //var touchLoc = CGPointFromString(touchLocStr)
//        
//        if let unit = Players[dataDict.objectForKey("userName") as String]
//        {
//            //println("here")
//            unit.apply(receivedOrder)
//        }
//        else
//        {
//            let newWarrior = Warrior(name: "hi2", health: 100, speed: CGFloat(100.0))
//            newWarrior.sprite.xScale = 0.3
//            newWarrior.sprite.yScale = 0.3
//            newWarrior.sprite.position = (receivedOrder as Move).position
//            self.addChild(newWarrior.sprite)
//            Players[dataDict.objectForKey("userName") as String] = newWarrior
//        }
//        //if let sprite = PlayerSprites[dataDict.objectForKey("userName") as String] {
//            
////            let charPos = sprite.position;
////            //localSprite.position = sprite.position
////            let xdif = touchLoc.x-charPos.x
////            let ydif = touchLoc.y-charPos.y
////            
////            let distance = sqrt((xdif*xdif)+(ydif*ydif))
////            let duration = distance/war.speed//PlayerSpeed
////            let action = SKAction.moveTo(touchLoc, duration:NSTimeInterval(duration))
////            //sprite.runAction(action)
////            sprite.runAction(action)
//            
//       // }
////        else {
////            //This is a new user that has not been seen before
////            //Create a new sprite for this user
////            let newSprite = SKSpriteNode(imageNamed:"Spaceship")
////            newSprite.xScale = 0.3
////            newSprite.yScale = 0.3
////            newSprite.position = touchLoc
////            self.addChild(newSprite)
////            PlayerSprites[dataDict.objectForKey("userName") as String] = newSprite
////        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
