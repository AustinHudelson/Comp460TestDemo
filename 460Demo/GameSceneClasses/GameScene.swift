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
    var targetingAbility: TargetedAbility?
    
    
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
        
        /* Spawn the player's Unit based on which class he/she picked & sends this unit over the network */
        switch AppWarpHelper.sharedInstance.playerClass {
            case "Mage":
                playerChar = Mage(ID: playerName, spawnLocation: playerCharPos)
            case "Priest":
                playerChar = Priest(ID: playerName, spawnLocation: playerCharPos)
            default:
                playerChar = Warrior(ID: playerName, spawnLocation: playerCharPos)
        }
        sendUnitOverNetwork(playerChar) //Adds and send the unit
        
        // Bg Music
        let soundAction = SKAction.playSoundFileNamed("DST-MapLands.mp3", waitForCompletion: true)
        let repeatSound = SKAction.repeatActionForever(soundAction)
        self.runAction(repeatSound, withKey: "BackgroundMusic")
        
        /*
            If I'm host, send a msg over the network telling everyone (including myself, the host) to load their level / first wave.
            The reason that the host dont immediately load the level here, but instead just send a msg about which level to load, is because game will be better synced if host waits until it gets it's own load level msg back before loading the level rather than loading the level before everyone else
        */
        if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host {
            Game.global.sendLoadLevelMsg()
        }
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
        NetworkManager.sendMsg(&sendData)
    }
    
  
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("Moved in to scene is Active:")
        println(sceneActive)
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
    
    override func willMoveFromView(view: SKView)
    {
        Game.global.scene = nil
        AppWarpHelper.sharedInstance.gameScene = nil
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

            /* variables related to exit confirmation window */
            var exitConfirm: SKNode? = self.childNodeWithName("exitConfirm")
            var exitConfirmYes: SKNode?
            var exitConfirmNo: SKNode?
            
            /*
                Determines if touch is on the exit button
            */
            if exitButton!.containsPoint(touchLocation)
            {
                /* Display exit confirmation window if it's not already there */
                if exitConfirm == nil {
                    println("displaying exit Window")
                    
                    exitConfirm = SKSpriteNode(imageNamed: "exitConfirm")
                    exitConfirm!.name = "exitConfirm"
                    exitConfirm!.position = CGPointMake(self.size.width/2, self.size.height/2)
                    self.addChild(exitConfirm!)
                    
//                    let exitConfirmYes = SKSpriteNode(imageNamed: "exitConfirmYes")
//                    exitConfirmYes.name = "exitConfirmYes"
//                    exitConfirm.position = CGPointMake(self.size.width/2, self.size.height/2)
//                    self.addChild(exitConfirm)
                }
                
                sceneActive = false
                AppWarpHelper.sharedInstance.leaveGame()
                println("exit pressed")
                
                self.removeAllActions()
                self.removeAllChildren()
                self.removeActionForKey("SyncAction")
                self.removeActionForKey("BackgroundMusic")
                self.viewController?.performSegueWithIdentifier("mainMenuSegue",sender:  nil)
                
                
                
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
            
            /* If Pressing Ability buttons
            */
            if Game.global.getMyPlayer() != nil {
                if Game.global.myPlayerIsDead == true || Game.global.getMyPlayer()!.alive == false {
                    return
                }
                //Check if targeting
                if (self.targetingAbility != nil){
                    self.targetingAbility!.giveTarget(touchLocation)
                    return
                }
                
                
                //Check button presses
                if self.childNodeWithName("Ability0")!.containsPoint(touchLocation) {
                    //Button at slot 0
                    let button = self.childNodeWithName("Ability0") as Ability
                    if button.cooldownReady == true {
                        button.buttonPressed(Game.global.getMyPlayer()!)
                        return
                    }
                } else if self.childNodeWithName("Ability1")!.containsPoint(touchLocation) {
                    //Button at slot 1
                    let button = self.childNodeWithName("Ability1") as Ability
                    if button.cooldownReady == true {
                        button.buttonPressed(Game.global.getMyPlayer()!)
                        return
                    }
                }
                else if self.childNodeWithName("Ability2")!.containsPoint(touchLocation) {
                    //Button at slot 2
                    let button = self.childNodeWithName("Ability2") as Ability
                    if button.cooldownReady == true {
                        button.buttonPressed(Game.global.getMyPlayer()!)
                        return
                        }
                    }
            }
            
            //Code only reaches here if touch is not a button press.
           if playerIsTouched == true || playerIsTouched == false {
                /*Just return if the player is dead */
                if (Game.global.getMyPlayer() == nil || Game.global.getMyPlayer()!.alive == false){
                    return
                }
                var unitTouched = false;
                var touchedUnitID: String = ""
                if (Game.global.getMyPlayer()?.isHealer == false){
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
                } else {
                    //My Player IS a healer
                    for (name, unit) in Game.global.playerMap   //Iterate over player map instead
                    {
                        //Attack target conditions go here
                        /* you touched the sprite, The target is not you, and the target is an enemy. */
                        if(unit.sprite.containsPoint(touchLocation) && (unit.isEnemy == false))
                        {
                            unitTouched = true;
                            touchedUnitID = unit.ID
                            break
                        }
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
                    if Game.global.getMyPlayer() != nil  {
                        var move_loc: Move = Move(receiverIn: Game.global.getMyPlayer()!, moveToLoc: touchLocation)
                        sendData["Orders"] = []
                        sendData["Orders"]!.append(move_loc.toJSON())
                    }
                }
                NetworkManager.sendMsg(&sendData)
                playerIsTouched = false
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
