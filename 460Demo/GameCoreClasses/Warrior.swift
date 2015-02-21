//
//  Warrior.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(Warrior)
class Warrior: Unit, PType
{
    var AnimationName = "Character1BaseColorization"
    var testProperty = "WRONG!"
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        restoreProperties(Warrior.self, receivedData: receivedData)
    }
    
    override init(name: String, ID:String, health: Int, speed: CGFloat, spawnLocation: CGPoint)
    {
        super.init(name: name, ID:ID, health: health, speed: speed, spawnLocation: spawnLocation)
        self.sprite.xScale = 0.5
        self.sprite.yScale = 0.5
        self.testProperty = "kinda Wrong!"
        self.setValue("TOTALLY RIGHT!", forKey: "testProperty")
        
        //self.sprite = SKSpriteNode(imageNamed:AnimationName+"-Stand")
        
        //self.apply(Move(position1: CGPoint(x: 1.0, y: 2.0)))
        //self.move(CGPoint(x: 400, y: 300))
        
        self.type = "Warrior"
    }
}
