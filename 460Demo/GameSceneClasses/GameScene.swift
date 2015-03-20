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
    var playerIsTouched = false
    var viewController: UIViewController?
    var sceneActive: Bool = true
    /*
        Update the game state according to dictionary received over the network
    */
    func updateGameState(recvDict: Dictionary<String, Array<AnyObject>>) {
        for (key: String, arrayOfObjects: Array<AnyObject>) in recvDict  {
            if key == "Units" {
                for object in arrayOfObjects {
                    let unit = object as Dictionary<String, AnyObject> // had to do this to get around Swift compile error
                    // Make a new unit by calling its corresponding constructor
                    if Game.global.getUnit(unit["ID"] as String) == nil
                    {
                        var anyobjecttype: AnyObject.Type = NSClassFromString(unit["type"] as NSString)
                        var nsobjecttype: Unit.Type = anyobjecttype as Unit.Type
                        var newUnit: Unit = nsobjecttype(receivedData: unit)
                        if !newUnit.isEnemy
                        {
                            Game.global.addPlayer(newUnit)
                            //If the player is NOT YOU give it a slightly grey tint.
                            if newUnit.ID != AppWarpHelper.sharedInstance.playerName {
                                newUnit.applyTint(UIColor.blackColor(), factor: 0.20, blendDuration: 0.0)
                            }
                        }
                        else
                        {
                            Game.global.addEnemy(newUnit)
                        }
                        
                        let spawnLoc = CGPoint(x: (unit["posX"] as CGFloat), y: (unit["posY"] as CGFloat))
                        
                        //newUnit.currentOrder = Idle(receiverIn: newUnit) //TEMPORARY WORKAROUND FOR ORDERS THAT DO NOT DESERIALIZE PROPERLY
                        
                        newUnit.addUnitToGameScene(self, pos: spawnLoc)
                    }
                }
            }
            if key == "Orders" {
                for object in arrayOfObjects {
                    let order = object as Dictionary<String, AnyObject>
                    // Make an Order object out of what is received
                    var anyobjecttype: AnyObject.Type = NSClassFromString(order["type"] as NSString)
                    var nsobjecttype: Order.Type = anyobjecttype as Order.Type
                    var newOrder: Order = nsobjecttype(receivedData: order)
                    if Game.global.getUnit(newOrder.ID!) != nil
                    {
                        Game.global.getUnit(newOrder.ID!)!.sendOrder(newOrder)   //SEND THE ORDER TO ITS UNIT
                        //newOrder.valueForKey("DS_receiver")
                    }
                    
                }
            }
            if key == "SentTime" {
                // Have to put the sent time in an array (even though it contains only 1 element) to get around Swift's compile error
                for object in arrayOfObjects {
                    let sentTimeStr = object as String
                    var sentTime: NSDate = Timer.StrToDate(sentTimeStr)!
                    var recvTime: NSDate = Timer.getCurrentTime()
                    var recvTimeStr = Timer.DateToStr(recvTime)
                    var diff: NSTimeInterval = Timer.diffDateNow(sentTime) // get difference between sent time and now
                    println("SentTime: \(sentTimeStr); RecvTime: \(recvTimeStr); diff between SentTime & recvTime: \(diff) seconds")
                }
            }
            
            // Sync players
            if key == "SyncPlayer" {
                    var syncPlayer: Dictionary<String, Dictionary<String, AnyObject>> = arrayOfObjects[0] as Dictionary<String, Dictionary<String, AnyObject>>
                
                    for (playerID, playerStats) in syncPlayer {
                        if Game.global.playerMap[playerID] != nil {
                            // if this sync msg's unitID is not my character, update it
                            if playerID != AppWarpHelper.sharedInstance.playerName {
                                Game.global.playerMap[playerID]!.health = playerStats["health"] as Float
                                Game.global.playerMap[playerID]!.DS_health_txt.text = Game.global.playerMap[playerID]!.health.description
                                
                                let playerPos: CGPoint = CGPoint(x: (playerStats["posX"] as CGFloat), y: (playerStats["posY"] as CGFloat))
                                var health_txt_pos = playerPos
                                health_txt_pos.y += Game.global.playerMap[playerID]!.health_txt_y_dspl
                                
                                Game.global.playerMap[playerID]!.sprite.position = playerPos
                                Game.global.playerMap[playerID]!.DS_health_txt.position = health_txt_pos
                            }
                        }
                    }
            }
            
            // Sync Enemies from host
            if key == "SyncEnemies" {
                var syncEnemies: Dictionary<String, Dictionary<String, AnyObject>> = arrayOfObjects[0] as Dictionary<String, Dictionary<String, AnyObject>>
                
                // If i'm not the host, sync the enemies
                if AppWarpHelper.sharedInstance.playerName != AppWarpHelper.sharedInstance.host {
                    for (enemyID, enemyStats) in syncEnemies {
                        if Game.global.enemyMap[enemyID] != nil {
                            Game.global.enemyMap[enemyID]!.health = enemyStats["health"] as Float
                            Game.global.enemyMap[enemyID]!.DS_health_txt.text = Game.global.enemyMap[enemyID]!.health.description
                            
                            let enemyPos: CGPoint = CGPoint(x: (enemyStats["posX"] as CGFloat), y: (enemyStats["posY"] as CGFloat))
                            var health_txt_pos = enemyPos
                            health_txt_pos.y += Game.global.enemyMap[enemyID]!.health_txt_y_dspl
                            
                            Game.global.enemyMap[enemyID]!.sprite.position = enemyPos
                            Game.global.enemyMap[enemyID]!.DS_health_txt.position = health_txt_pos
                        }
                    }
                }
            }
        }
    }
    
    //begins game scene by making your player and loading enemy waves if you are host
    func startGameScene() {
        println("GAME SCENE START")
        var playerName = AppWarpHelper.sharedInstance.playerName
        var playerChar: Unit
        var charDisplacement = 0
        for index in 0 ..< AppWarpHelper.sharedInstance.userName_list.count
        {
            if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.userName_list[index] as String
            {
                charDisplacement = index
            }
        }
    
        let playerCharPos: CGPoint = CGPoint(x:CGRectGetMidX(self.frame).advancedBy(CGFloat(charDisplacement*100-150)), y:CGRectGetMidY(self.frame))
        
        if AppWarpHelper.sharedInstance.playerClass == "Mage" {
            /*
                TEMPORARY to test a mage class: If playerName == "Mage", give him a mage & set ID = playerName
            */
            playerChar = Mage(ID: playerName, spawnLocation: playerCharPos)
        }
            //change for class 3
        else if AppWarpHelper.sharedInstance.playerClass == "saldfjals;jkf" {
            playerChar = Warrior(ID: playerName, spawnLocation: playerCharPos)}
            
            //change for class 4
        else if AppWarpHelper.sharedInstance.playerClass == "sadfkasdjf;" {
            playerChar = Warrior(ID: playerName, spawnLocation: playerCharPos)}
        else {
            /*
                Else create a warrior unit with ID = playerName
            */
            playerChar = Warrior(ID: playerName, spawnLocation: playerCharPos)
        }
        
        
        sendUnitOverNetwork(playerChar) //Adds and send the unit
        
        Game.global.level = LevelOne(scene: Game.global.scene!)
        Game.global.loadLevel()
        
        
    }
    
    //Does all work necessary to add a unit to the game for all connected players
    func sendUnitOverNetwork(newUnit: Unit){
        
        //Dont send anything if this scene is no longer active (destroyed)
        if sceneActive == false {
            println("Warning tried to send create unit from a non active scene")
            return
        }
        
        
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Units"] = []
        sendData["Units"]!.append(newUnit.toJSON())
        AppWarpHelper.sharedInstance.sendUpdate(&sendData)
    }
    
  
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("Moved in to scene is Active:")
        println(sceneActive)
        println("Textures done loading: ")
        println(TextureLoader.global.preloaded)
        Game.global.clearGlobals()
        Game.global.scene = self
//        /* Setup game background image */
//        let background = SKSpriteNode(imageNamed: "Background1")
//        background.position = CGPointMake(self.size.width/2, self.size.height/2)
//        background.size = CGSize(width: CGFloat(self.size.width), height: CGFloat(self.size.height));
//        background.position = CGPoint(x: 0, y: 0)
//        background.anchorPoint = CGPoint(x: 0, y: 1.0)
//        addChild(background)
        
        
        AppWarpHelper.sharedInstance.gameScene = self
        startGameScene()
        
        Game.global.addSyncActionToScene()
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
     
        //println("Hit")
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let exitButton = self.childNodeWithName("exitButton")
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)

            
            
            /*
            *  Determines if touch end button
            */
            if exitButton!.containsPoint(touchLocation)
            {
                sceneActive = false
                AppWarpHelper.sharedInstance.leaveGame()
                println("exit pressed")
                
                self.viewController?.performSegueWithIdentifier("mainMenuSegue",sender:  nil)
                self.removeAllActions()
                self.removeAllChildren()
                
            }
            
            /* When touching your own player
            */

            if !Game.global.myPlayerIsDead
            {
                if Game.global.getMyPlayer() != nil {
                    if Game.global.getMyPlayer()!.sprite.containsPoint(touchLocation) {
                            playerIsTouched = true
                    }
                }
            }
                
        }
    }
    
    override func touchesEnded(touches:NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            if playerIsTouched == true {
                
                var unitTouched = false;
                var touchedUnitID: String = ""
                for (name, unit) in Game.global.enemyMap
                {
                    //Attack target conditions go here
                    /* you touched the sprite, The target is not you, and the target is an enemy. */
                    if(unit.sprite.containsPoint(touchLocation) && (unit.isEnemy == true))
                    {
                        unitTouched = true;
                        touchedUnitID = unit.ID
                        break
                    }
                }
                
                var sendData: Dictionary<String, Array<AnyObject>> = [:]
                if(unitTouched)
                {
                    if Game.global.getMyPlayer() != nil {
                        var attack: Attack = Attack(receiverIn: Game.global.getMyPlayer()!, target: Game.global.getUnit(touchedUnitID)!)
                        sendData["Orders"] = []
                        sendData["Orders"]!.append(attack.toJSON())
                    }
                    
                }
                else
                {
                    if Game.global.getMyPlayer() != nil {
                        var move_loc: Move = Move(receiverIn: Game.global.getMyPlayer()!, moveToLoc: touchLocation)
                        sendData["Orders"] = []
                        sendData["Orders"]!.append(move_loc.toJSON())
                    }
                }
                AppWarpHelper.sharedInstance.sendUpdate(&sendData)
                playerIsTouched = false
            }
            /* If Pressing Ability buttons
            */
            
            else
            {
                if Game.global.getMyPlayer() != nil {
                    if Game.global.myPlayerIsDead == true || Game.global.getMyPlayer()!.alive == false {
                        return
                    }
                
                    if self.childNodeWithName("Ability0")!.containsPoint(touchLocation) {
                        //Button at slot 0
                        let button = self.childNodeWithName("Ability0") as Ability
                        if button.cooldownReady == true {
                            button.apply(Game.global.getMyPlayer()!)
                        }
                    } else if self.childNodeWithName("Ability1")!.containsPoint(touchLocation) {
                        //Button at slot 1
                        let button = self.childNodeWithName("Ability1") as Ability
                        if button.cooldownReady == true {
                            button.apply(Game.global.getMyPlayer()!)
                        }
                    }
                }
            }
          }
    }
    
    var TEMPREMOVECOUNTER: Int = 0
    
    override func update(currentTime: CFTimeInterval) {
//        /*
//            Go through each unit in the unit_list and do a runAction on their corresponding Order
//        */
//        
//        //SIMULATE UPDATE LOOP. THIS IS LIKE THE WORST WAY TO DO THIS EVER!
//        TEMPREMOVECOUNTER += 1
//        if (TEMPREMOVECOUNTER == 10){
//            TEMPREMOVECOUNTER = 0
//            for (id, unit) in Game.global.unitMap {   //TEMP FIX
//                unit.update()
//            }
//        }
        
    }
}
