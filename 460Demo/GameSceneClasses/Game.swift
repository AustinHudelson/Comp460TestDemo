//
//  Game.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit


class Game {
    
    var unitMap: Dictionary<String, Unit> = [:] // Our list of units in the scene
    var scene: GameScene?
    
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
    
    func addUnit(unit: Unit){
        if unitMap[unit.ID] == nil{
            unitMap[unit.ID] = unit
        } else {
            println("WARNING: ADDED UNIT WITH ALREADY EXISTING ID TO GAME")
        }
    }
    
    func removeUnit(unit: Unit){
        if unitMap[unit.ID] != nil{
//            scene!.removeUnitFromGame(unit.ID)
            unitMap[unit.ID] = nil
            let remove: SKAction = SKAction.removeFromParent()
            unit.DS_health_txt.runAction(remove)
            unit.sprite.runAction(remove)
            
            // Temporary Lose Screen for if the unit removed is your character
            if unit.ID == AppWarpHelper.sharedInstance.playerName {
                // Show Game over text
                var GameOver_txt: SKLabelNode = SKLabelNode(text: "Game Over")
                GameOver_txt.fontColor = UIColor.whiteColor()
                GameOver_txt.fontSize = 100
                
                GameOver_txt.position = CGPointMake(scene!.size.width/2, scene!.size.height*(5/6))
                scene!.addChild(GameOver_txt)
            }
        } else {
            println("WARNING: ATTEMPTED TO REMOVE UNIT FROM UNITMAP THAT COULD NOT BE FOUND")
        }
    }
    
    func removeUnit(ID: String){
        removeUnit(unit(ID))
    }
    
    func unit(ID: String) -> Unit{
        return unitMap[ID]!
    }
    
    func getUnit(ID: String) -> Unit{
        return unit(ID)
    }
    
    func getMyPlayer() -> Unit {
        return unit(AppWarpHelper.sharedInstance.playerName)
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
        
        for (id, unit) in Game.global.unitMap {
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