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
            }
        }
            
        else if enemyMap[ID] != nil//it's an enemy
        {
            var enemy = enemyMap[ID]!
            playerMap[ID] = nil
            let remove: SKAction = SKAction.removeFromParent()
            enemy.DS_health_txt.runAction(remove)
            enemy.sprite.runAction(remove)
            
            if enemyMap.count == 0
            {
                loadLevel()
            }
            
        }
        else
        {
            println("The ID of this unit does not exist")
            
        }
     }
    
    /*
     * loads a new wave if you are the host
     */
    func loadLevel()
    {
        if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host
        {
            var firstWave: Array<Enemy>? = Game.global.level!.loadWave()
            
            if firstWave != nil
            {
                for enemy in firstWave!
                {
                    scene!.sendUnitOverNetwork(enemy)
                }
            }
            else
            {
                winGame()
            }
            
            
        }
    }
    
    /** Once all waves are complete then we show this text/screen
    */
    
    func winGame()
    {
        println("We won")
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
            println("The ID of this unit does not exist")
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
    * Returns the closest PLAYER to the given point
    */
    func getClosestPlayer(p1: CGPoint) -> Unit? {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in Game.global.playerMap {
            if unit is Enemy{   //WARNING: THIS IS A TERRIBLE WAY TO CHECK ALLIANCE... MUST UPDATE LATER
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
}