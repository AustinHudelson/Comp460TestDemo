//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var unit_list: Dictionary<String, Unit> = [:] // Our list of units in the scene
    var playerIsTouched = false
    
    /*
        Update the game state according to dictionary received over the network
    */
    func updateGameState(recvDict: Dictionary<String, Array<Dictionary<String, AnyObject>>>) {
        for (key: String, arrayOfObjects: Array<Dictionary<String, AnyObject>>) in recvDict {
            if key == "Units" {
                for unit in arrayOfObjects {
                    // Make a new unit by calling its corresponding constructor
                    if unit_list[unit["ID"] as String] == nil {
                        var anyobjecttype: AnyObject.Type = NSClassFromString(unit["type"] as NSString)
                        var nsobjecttype: Unit.Type = anyobjecttype as Unit.Type
                        var newUnit: Unit = nsobjecttype(receivedData: unit)
                        
                        unit_list[newUnit.ID] = newUnit
                        let spawnLoc = CGPoint(x: (unit["posX"] as CGFloat), y: (unit["posY"] as CGFloat))
                        newUnit.addUnitToGameScene(self, pos: spawnLoc, scaleX: 1.0, scaleY: 1.0)
                        
                        addUnitToGame(unit_list[AppWarpHelper.sharedInstance.playerName]!) // send myself to everyone who hasn't got me
                    }
                }
            }
            if key == "Orders" {
                //TODO
            }
        }
    }

    func startGameScene() {
        println("GAME SCENE START")
        
        // Create a warrior unit with name = player name
        var playerName = AppWarpHelper.sharedInstance.playerName
        let war_position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        let war = Warrior(name: playerName, ID:playerName, health: 100, speed: CGFloat(100.1), spawnLocation: war_position)
        
        addUnitToGame(war) //Adds and send the unit
        
        //Create a unit on the scene, should have the same ID for all players so should only create one time
        let DUMMY_ID = "1"
        let dummy_position = CGPoint(x:CGRectGetMidX(self.frame)+50, y:CGRectGetMidY(self.frame));
        let dummy = Warrior(name: "Dummy", ID: DUMMY_ID, health: 100, speed: CGFloat(80.0), spawnLocation: dummy_position)
        
//        addUnitToGame(dummy)
    }
    
    //Does all work necessary to add a unit to the game for all connected players
    func addUnitToGame(newUnit: Unit){
        //unit_list[newUnit.ID] = newUnit
        //newUnit.addUnitToGameScene(self, pos: position, scaleX: 0.5, scaleY: 0.5)
        
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Units"] = []
        sendData["Units"]!.append(newUnit.toJSON())
        AppWarpHelper.sharedInstance.sendUpdate(sendData)
    }
    
    func removeUnitFromGame(unit: Unit){
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Kill"]!.append(unit.ID)
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
        
        // physics
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        //
        
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
                    sendData["Orders"]!.append(attack.toJSON())
                    
                }
                else
                {
                    var move_loc: Move = Move(receiverIn: unit_list[AppWarpHelper.sharedInstance.playerName]!, moveToLoc: touchLocation)
                    sendData["Orders"] = []
                    sendData["Orders"]!.append(move_loc.toJSON())
                    
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
