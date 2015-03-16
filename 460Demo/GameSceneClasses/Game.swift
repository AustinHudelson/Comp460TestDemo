//
//  Game.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

/*
* Global class that handles units and game interaction
*/
class Game {
    
    //var unitMap: Dictionary<String, Unit> = [:]
    var playerMap: Dictionary<String, Unit> = [:] // Our list of players in the scene
    var enemyMap: Dictionary<String,Unit> = [:] //our list of AI characters
    var scene: GameScene?
    var level: Level?
    var myPlayerIsDead = false
    
    class var global:Game{
        struct Static{
            static var instance:Game?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            Static.instance = Game()
        }
        return Static.instance!
    }
    
    /*
     * Clears all the global data in this class to the default values
     */
    func clearGlobals(){
        for (id, unit) in Game.global.playerMap{
            unit.death()
        }
        for (id, unit) in Game.global.enemyMap{
            unit.death()
        }
        playerMap = [:]
        enemyMap = [:]
        myPlayerIsDead = false
    }
    
    
    /*
     *  Adds a Unit respresenting a player
     */
    func addPlayer(player: Unit){
        if playerMap[player.ID] == nil{
            playerMap[player.ID] = player
        } else {
            println("WARNING: ADDED UNIT WITH ALREADY EXISTING ID TO GAME")
        }
    }
    /*
     *Adds an enemy
     */
    func addEnemy(enemy: Unit)
    {
        if enemyMap[enemy.ID] == nil{
            enemyMap[enemy.ID] = enemy
        } else {
            println("WARNING: ADDED UNIT WITH ALREADY EXISTING ID TO GAME")
        }
    }
    
    /*
     */
    func removeUnit(ID:String){
        println("removing unit")
        if playerMap[ID] != nil
        {
            
            var player = playerMap[ID]!
            playerMap[ID] = nil
            let remove: SKAction = SKAction.removeFromParent()
            player.DS_health_txt.runAction(remove)
            player.sprite.runAction(remove)
            if ID == AppWarpHelper.sharedInstance.playerName
            {
                myPlayerIsDead = true
                localPlayerloseGame()
            }
            
            // Check if this player removal results in empty playerMap, if it is, the team loses
            if playerMap.count <= 0 {
                loseGame()
            }
        }
            
        else if enemyMap[ID] != nil//it's an enemy
        {
            println("removing enemy")
            var enemy = enemyMap[ID]!
            enemyMap[ID] = nil
            let remove: SKAction = SKAction.removeFromParent()
            enemy.DS_health_txt.runAction(remove)
            enemy.sprite.runAction(remove)
           
            if enemyMap.count == 0
            {
                println("getting new wave")
                loadLevel()
            }
            
        }
        else
        {
            println("The ID of this unit does not exist to remove")
            
        }
     }
    
    /*
     * loads a new wave if you are the host
     */
    func loadLevel()
    {
        if Game.global.level!.hasMoreWaves()
        {
            var firstWave: Array<Unit>? = Game.global.level!.loadWave()
            if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host
            {
                for enemy in firstWave!
                {
                    scene!.sendUnitOverNetwork(enemy)
                }
            }
        }
        else
        {
            winGame()
        }
        
    }
    
    /** Once all waves are complete then we show this text/screen
    */
    
    func winGame()
    {
        println("You Win!!!")
        let winText: SKLabelNode = SKLabelNode(text: "You Win!")
        winText.fontSize = 50
        winText.fontName = "AvenirNext-Bold"
        winText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        winText.zPosition = 1
        if let localLoseText = self.scene!.childNodeWithName("localLoseText") {
            localLoseText.removeFromParent()
        }
        self.scene!.addChild(winText)
    }
    func localPlayerloseGame()
    {
        println("You have died...")
        let localLoseText: SKLabelNode = SKLabelNode(text: "You have died...")
        localLoseText.name = "localLoseText"
        localLoseText.fontName = "AvenirNext-Bold"
        localLoseText.fontSize = 50
        localLoseText.zPosition = 1
        localLoseText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        self.scene!.addChild(localLoseText)
    }
    func loseGame()
    {
        println("Your team has lost...")
        let loseText: SKLabelNode = SKLabelNode(text: "You Lose!\n Game Over")
        loseText.fontName = "HelveticaNeue-Bold"
        loseText.name = "loseText"
        loseText.zPosition = 1
        loseText.fontSize = 50
        loseText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        
        /*
            Check if the localLoseText is there, if it is, remove it
        */
        if let localLoseText = self.scene!.childNodeWithName("localLoseText") {
            localLoseText.removeFromParent()
        }
        
        self.scene!.addChild(loseText)
        self.scene!.removeActionForKey("SyncAction")
    }
    
    /* Gets a unit given a String
    */
    func getUnit(ID: String) -> Unit?{
        if playerMap[ID] != nil
        {
            return playerMap[ID]!
        }
            
        else if enemyMap[ID] != nil//it's an enemy
        {
            return enemyMap[ID]!
        }
        else
        {
            println("The ID of this unit does not exist to get")
            return nil
        }
            
    }
   
    
    
    /* Returns your Unit
    */
    func getMyPlayer() -> Unit {
        return playerMap[AppWarpHelper.sharedInstance.playerName]!
    }
    
    /*
    *Function to get distance between 2 CGPoints
    */
    func getDistance(p1: CGPoint, p2: CGPoint) -> CGFloat{
        let xDist = (p2.x - p1.x);
        let yDist = (p2.y - p1.y);
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    /*
    * Function to QUICKLY get a RELATIVE distance.
    * Does not run the sqrt function, instead simply returns its square.
    * When comparing distances it is not required to know the actual distance.
    */
    func getRelativeDistance(p1: CGPoint, p2: CGPoint) -> CGFloat{
        let xDist = (p2.x - p1.x);
        let yDist = (p2.y - p1.y);
        return ((xDist * xDist) + (yDist * yDist));
    }
    
    /*
     * Gets the CGPoint offset towards offset towards the target point.
     */
    func getPointOffsetTowardPoint(p1: CGPoint, p2: CGPoint, distance: CGFloat) -> CGPoint{
        let theta = atan2((p2.y-p1.y), (p2.x-p1.x))
        let x = p1.x+(distance*cos(theta))
        let y = p1.y+(distance*sin(theta))
        return CGPoint(x:x, y:y)
    }
    
    /*
    * Returns the closest PLAYER to the given point
    */
    func getClosestPlayer(p1: CGPoint) -> Unit? {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in Game.global.playerMap {
            if unit.alive == false {
                continue
            }
            var p2 = unit.sprite.position
            var dist = getRelativeDistance(p1, p2:p2)
            if dist < near{
                nearby = unit
                near = dist
            }
        }
        
//        if nearby == nil {
//            fatalError("Unable to find closest player to point. Empty player list?")
//        }
        
        return nearby
    }

    /*
    * Returns the closest ENEMY to the given point
    */
    func getClosestEnemy(p1: CGPoint) -> Unit? {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in Game.global.enemyMap {
            if unit.alive == false {
                continue
            }
            var p2 = unit.sprite.position
            var dist = getRelativeDistance(p1, p2:p2)
            if dist < near{
                nearby = unit
                near = dist
            }
        }
        
//        if nearby == nil {
//            fatalError("Unable to find closest player to point. Empty player list?")
//        }
        
        return nearby
    }
    
    // Host will call this to send host's char and every enemy's health and position every X seconds
    /*
        Our sent dicitonary will look like this:
        ["Sync":
            [
                "ID1": [
                        "health": 100,
                        "posX": 50,
                        "posY": 60
                        ],
                "ID2": ...
            ]
        ]
    */
    func sendHostSynch() {
        var outerDict: Dictionary<String, Array<AnyObject>> = [:]
        outerDict["Sync"] = []
        
        var syncData: Dictionary<String, Dictionary<String, AnyObject>> = [:]
        
        let playerID = AppWarpHelper.sharedInstance.playerName
        if playerMap[playerID] != nil {
            let playerUnit = playerMap[playerID]!
        
            var playerStats: Dictionary<String, AnyObject> = [:]
            playerStats["health"] = playerUnit.health
            playerStats["posX"] = Float(playerUnit.sprite.position.x)
            playerStats["posY"] = Float(playerUnit.sprite.position.y)
            syncData[playerID] = playerStats
        }
        
        for (enemyID, enemyUnit) in enemyMap {
            var enemyStats: Dictionary<String, AnyObject> = [:]
            enemyStats["health"] = enemyUnit.health
            enemyStats["posX"] = Float(enemyUnit.sprite.position.x)
            enemyStats["posY"] = Float(enemyUnit.sprite.position.y)
            
            syncData[enemyID] = enemyStats
        }
        
        outerDict["Sync"]!.append(syncData)
        
        AppWarpHelper.sharedInstance.sendUpdate(&outerDict)
    }
    
    // Clients will call this to send their own char's health and pos
    func sendClientSync() {
        let playerID = AppWarpHelper.sharedInstance.playerName
        
        if playerMap[playerID] != nil {
            var outerDict: Dictionary<String, Array<AnyObject>> = [:]
            outerDict["Sync"] = []
            
            var syncData: Dictionary<String, Dictionary<String, AnyObject>> = [:]
            
            
            let playerUnit = playerMap[playerID]!
            
            var playerStats: Dictionary<String, AnyObject> = [:]
            playerStats["health"] = playerUnit.health
            playerStats["posX"] = Float(playerUnit.sprite.position.x)
            playerStats["posY"] = Float(playerUnit.sprite.position.y)
            syncData[playerID] = playerStats
            
            outerDict["Sync"]!.append(syncData)
            
            AppWarpHelper.sharedInstance.sendUpdate(&outerDict)
        }

    }
    
    func addSyncActionToScene() {
        let sendInterval: SKAction = SKAction.waitForDuration(NSTimeInterval(0.5))
        
        var syncAction: SKAction
        // Send sync msg every X seconds if I'm host
        if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host {
            syncAction = SKAction.runBlock(Game.global.sendHostSynch)
        } else {
            syncAction = SKAction.runBlock(Game.global.sendClientSync)
        }
        
        let sendSync: SKAction = SKAction.sequence([sendInterval, syncAction])
        let repeatAction: SKAction = SKAction.repeatActionForever(sendSync)
        self.scene?.runAction(repeatAction, withKey: "SyncAction")
    }

}