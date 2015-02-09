//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit



class GameScene: SKScene {
    
    var unit_list: Dictionary<String, Unit> = [:] // Our list of units in the scene
    var playerIsTouched = false
    
    /*
        This function creates a unit on the screen & sends this unit over the network to peers
        - It only creates a player of type Warrior right now
    */
    func createUnit(unitName: String, health: Int, speed: CGFloat) -> Unit {
        return Warrior(name: unitName, health: health, speed: speed)
    }
    /*
        Update the game state according to data received over the network
        - Eg. usage of recvData assuming the data sent is the example from sendUpdate():
            let unit_list = recvData["Units"].arrayObject
            // unit_list is now [Unit(player1), Unit(player2), Unit(enemy1), Unit(enemey2)],
    */
    func updateGameState(recvData: JSON) {
        /* 
            Loop through all the avaiable keys in the received JSON, which, at the outer most layer,
            should be a dictionary
        */
        for (key: String, subArray: JSON) in recvData {
            /* ========== Units ========== */
            if key == "Units" {
                let recv_unit_list: Array<JSON> = recvData["Units"].array!
                /*
                    Check the recieved unit list against our local unit list, if there are any new units, add them
                */
                for recv_unit in recv_unit_list {
                    var recv_name = recv_unit["name"].stringValue
                    if unit_list[recv_name] == nil {
                        // Create this new unit
                        var unit_name = recv_unit["name"].stringValue
                        var unit_health = recv_unit["health"].intValue
                        var unit_speed = recv_unit["speed"].floatValue
                        var unit_posX = recv_unit["posX"].floatValue
                        var unit_posY = recv_unit["posY"].floatValue

                        var new_unit = createUnit(unit_name, health: unit_health, speed: CGFloat(unit_speed))

                        // put it in our local unit list
                        unit_list[recv_name] = new_unit
                        // Add this Unit's sprite to scene
                        new_unit.addUnitToGameScene(self, pos: CGPoint(x: CGFloat(unit_posX), y: CGFloat(unit_posY)), scaleX: 0.25, scaleY: 0.25)

                        /*
                            !!!CHANGE THIS LATER!!!
                            Since the only new unit we'll be receiving right now is a new player unit,
                            broadcast my player's Unit over the network to whoever sent me his new player unit
                        */
                        var sendData: Dictionary<String, Array<AnyObject>> = [:]
                        sendData["Units"] = []
                        sendData["Units"]!.append(unit_list[AppWarpHelper.sharedInstance.playerName]!.toJSONDict())
                        AppWarpHelper.sharedInstance.sendUpdate(sendData)
                    }
                }
            }
            /* ========== Orders =========== */
            if key == "Orders" {
                let recv_order_list: Array<JSON> = recvData["Orders"].array!
                for order in recv_order_list {
                    var orderType = order["orderType"].stringValue
                    var sender = order["sender"].stringValue
                    
                    if (orderType == "Move") {
                        var pos_x = order["x"].intValue
                        var pos_y = order["y"].intValue
                        var new_order = Move(sender: sender, receiver: "", position1: CGPoint(x: pos_x, y: pos_y))
                        
                        unit_list[sender]!.apply(new_order)
                    }
                    if (orderType == "Attack") {
                        var sender = order["sender"].stringValue
                        var receiver = order["receiver"].stringValue
                        var new_order = Attack(sender: sender, receiver: receiver)
                        unit_list[sender]!.apply(new_order, target: unit_list[receiver]!)
                    }
                }
            }
        }
    }

    func startGameScene() {
        // Create a warrior unit with name = player name
        var playerName = AppWarpHelper.sharedInstance.playerName
        let war = createUnit(playerName, health: 100, speed: CGFloat(100.1))
        let war_position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        // Add the warrior to our list of units in the scene
        unit_list[playerName] = war
        
        // Tell SpriteKit to actually draw the the initially create Units in scene
        for unit in unit_list {
            war.addUnitToGameScene(self, pos: war_position, scaleX: 0.5, scaleY: 0.5)
        }
        
        // Send the initial units data over appwarp
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Units"] = []
//        sendData["Orders"]=[]
        sendData["Units"]!.append(unit_list[playerName]!.toJSONDict())
        
        AppWarpHelper.sharedInstance.sendUpdate(sendData)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("Game Scene Init")
        AppWarpHelper.sharedInstance.gameScene = self
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)

            /*
                Determine if the touch is on your own character's sprite
            */

                if unit_list[AppWarpHelper.sharedInstance.playerName]!.sprite.containsPoint(touchLocation) {
                    playerIsTouched = true
                }
        }
    }
    override func touchesEnded(touches:NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            if playerIsTouched == true {
                let touchLocation = touch.locationInNode(self)
//                //Make a muteable dictionary to send over appwarp
//                    var dataDict = NSMutableDictionary()
//                    
//                    //Store the userName/playerName in the sending dictionary
//                    //Set the username for the muteable dictionary
//                    dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "userName")
//                
//                var touchedUnit = war as Unit
                var unitTouched = false;
                var touchedUnitName: String = ""
                for (name, unit) in unit_list
                {
                    if(unit.sprite.containsPoint(touchLocation) && (unit.name != AppWarpHelper.sharedInstance.playerName))
                    {
                        unitTouched = true;
                        touchedUnitName = unit.name
                        break
                    }
                }
                
                var sendData: Dictionary<String, Array<AnyObject>> = [:]
                if(unitTouched)
                {
//                    var attack = Attack(tar: touchedUnit)
//                    dataDict.setObject(attack.description, forKey: "attack")
                    var attack: Attack = Attack(sender: AppWarpHelper.sharedInstance.playerName, receiver: touchedUnitName)
//                    sendData["Units"] = []
                    sendData["Orders"] = []
                    sendData["Orders"]!.append(attack.toJSONDict())
                    
                }
                else
                {
                    var move_loc: Move = Move(sender: AppWarpHelper.sharedInstance.playerName, receiver: "", position1: touchLocation)
                    sendData["Orders"] = []
                    sendData["Orders"]!.append(move_loc.toJSONDict())
                    
//                    for unit in unit_list
//                    {
//                        if unit.name == AppWarpHelper.sharedInstance.playerName
//                        {
//                            unit.apply(move_loc)
//                            break
//                        }
//                        
//                    }
                    
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
                }
                AppWarpHelper.sharedInstance.sendUpdate(sendData)
                playerIsTouched = false
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
