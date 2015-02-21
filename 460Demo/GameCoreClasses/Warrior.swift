//
//  Warrior.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
@objc(Warrior)
class Warrior: Unit, PType
{
    var AnimationName = "Character1BaseColorization"
    var testProperty = "WRONG!"
    
    override var type: String {
        return "Warrior"
    }
    
    override init(recievedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(recievedData: recievedData)
        
        var aClass : AnyClass? = Warrior.self       //ADJUST FOR EACH CLASS?
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        //var propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
        
        for var i = 0; i < Int(propertiesCount); i++ {
            var property = propertiesInAClass[i]
            var propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)! as String
            var propType = property_getAttributes(property)
            
            //Check if the key is in the dictionary (only DS_ and sprite should not appear here)
            if recievedData[propName] != nil {
                let propValue = recievedData[propName]
                self.setValue(propValue, forKey: propName)
            } else {
                println("Unable to find value for property: "+propName)
            }
        }
    }
    
    override init(name: String, ID:String, health: Int, speed: CGFloat)
    {
        super.init(name: name, ID:ID, health: health, speed: speed)
        self.sprite.xScale = 0.5
        self.sprite.yScale = 0.5
        self.testProperty = "RIGHT!"
        
        //self.sprite = SKSpriteNode(imageNamed:AnimationName+"-Stand")
        
        //self.apply(Move(position1: CGPoint(x: 1.0, y: 2.0)))
        //self.move(CGPoint(x: 400, y: 300))
    }
}
