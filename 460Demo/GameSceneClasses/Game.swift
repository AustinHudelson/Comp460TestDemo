//
//  Game.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation


class Game {
    
    var unitMap: Dictionary<String, Unit> = [:] // Our list of units in the scene
    
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
            unitMap[unit.ID] = nil
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
}