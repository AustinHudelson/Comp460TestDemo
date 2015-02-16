//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var unit_list: Dictionary<String, Unit> = [:] // Our list of units in the scene
    var playerIsTouched = false
    
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
                    var recv_name = recv_unit["ID"].stringValue
                    if unit_list[recv_name] == nil {
                        // Create this new unit
                        var unit_name = recv_unit["name"].stringValue
                        var unit_ID = recv_unit["ID"].stringValue
                        var unit_health = recv_unit["health"].intValue
                        var unit_speed = recv_unit["speed"].floatValue
                        var unit_posX = recv_unit["posX"].floatValue
                        var unit_posY = recv_unit["posY"].floatValue

                        var new_unit = Unit(name: unit_name, ID: unit_ID, health: unit_health, speed: CGFloat(unit_speed))

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
                    //WARNING SENDER AND RECEIVER GET CONFUSED HERE!
                    //IN ORDER OBJECTS RECIEVER IS THE UNIT RECEIVING THE ORDER
                    //HERE THE SENDER IS THE NAME OF THE UNIT RECEIVING THE ORDER
                    var orderType = order["orderType"].stringValue
                    var receiver: Unit = unit_list[order["receiver"].stringValue]!
                    
                    if (orderType == "Move") {
                        var pos_x = order["x"].intValue
                        var pos_y = order["y"].intValue
                        var new_order = Move(receiverIn: receiver, moveToLoc: CGPoint(x: pos_x, y: pos_y))
                        receiver.sendOrder(new_order)
                    }
                    if (orderType == "Attack") {
                        var receiver: Unit = unit_list[order["receiver"].stringValue]!
                        var target: Unit = unit_list[order["target"].stringValue]!
                        var new_order = Attack(receiverIn: receiver, target: target)
                        receiver.sendOrder(new_order)
                    }
                    
                }
            }
        }
    }

    func startGameScene() {
        println("GAME SCENE START")
        
        // Tell SpriteKit to actually draw the the initial Units in scene
        //for unit in unit_list {
        //    war.addUnitToGameScene(self, pos: war_position, scaleX: 0.5, scaleY: 0.5)
        //}
        
        // Create a warrior unit with name = player name
        var playerName = AppWarpHelper.sharedInstance.playerName
        let war = Warrior(name: playerName, ID:playerName, health: 100, speed: CGFloat(100.1))
        let war_position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        addUnitToGame(war, position: war_position) //Adds and send the unit
        
        //Create a unit on the scene, should have the same ID for all players so should only create one time
        let DUMMY_ID = "1"
        let dummy = Warrior(name: "Dummy", ID: DUMMY_ID, health: 100, speed: CGFloat(80.0))
        let dummy_position = CGPoint(x:CGRectGetMidX(self.frame)+50, y:CGRectGetMidY(self.frame));
        addUnitToGame(dummy, position: dummy_position)
        
        
        
        
        // Send the initial unit data over appwarp
        //var sendData: Dictionary<String, Array<AnyObject>> = [:]
        //sendData["Units"] = []
        //sendData["Orders"]=[]
        //sendData["Units"]!.append(unit_list[playerName]!.toJSONDict())
        
        //AppWarpHelper.sharedInstance.sendUpdate(sendData)
    }
    
    //Does all work necessary to add a unit to the game for all connected players
    func addUnitToGame(newUnit: Unit, position: CGPoint){
        unit_list[newUnit.ID] = newUnit
        newUnit.addUnitToGameScene(self, pos: position, scaleX: 0.5, scaleY: 0.5)
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Units"] = []
        sendData["Units"]!.append(unit_list[newUnit.ID]!.toJSONDict())
        AppWarpHelper.sharedInstance.sendUpdate(sendData)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("Game Scene Init")
        AppWarpHelper.sharedInstance.gameScene = self
        
        let background = SKSpriteNode(imageNamed: "Background1")
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        background.size = CGSize(width: CGFloat(self.size.width), height: CGFloat(self.size.height));
        //background.position = CGPoint(x: 0, y: 0)
        //background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        
        //// physics
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        ////
        
    }
    
    /// physics
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstNode = contact.bodyA.node as SKSpriteNode
        let secondNode = contact.bodyB.node as SKSpriteNode
        
        //firstNode.removeActionForKey("move")
        //firstNode.removeActionForKey("moveAnim")
        let contactPoint = contact.contactPoint
        let contact_y = contactPoint.y
        let target_y = secondNode.position.y
        let margin = secondNode.frame.size.height/2 - 25
     
                println("Hit")
        
    }
    ////
    
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
                var unitTouched = false;
                var touchedUnitID: String = ""
                for (name, unit) in unit_list
                {
                    //Attack target conditions go here
                    if(unit.sprite.containsPoint(touchLocation) && (unit.ID != AppWarpHelper.sharedInstance.playerName))
                    {
                        unitTouched = true;
                        touchedUnitID = unit.ID
                        break
                    }
                }
                
                var sendData: Dictionary<String, Array<AnyObject>> = [:]
                if(unitTouched)
                {
                    var attack: Attack = Attack(receiverIn: unit_list[AppWarpHelper.sharedInstance.playerName]!, target: unit_list[touchedUnitID]!)
                    sendData["Orders"] = []
                    sendData["Orders"]!.append(attack.toJSONDict())
                    
                }
                else
                {
                    var move_loc: Move = Move(receiverIn: unit_list[AppWarpHelper.sharedInstance.playerName]!, moveToLoc: touchLocation)
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

    override func update(currentTime: CFTimeInterval) {
        /*
            Go through each unit in the unit_list and do a runAction on their corresponding Order
        */
        
    }
}
