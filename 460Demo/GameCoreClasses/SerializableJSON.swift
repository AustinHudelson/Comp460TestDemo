//
//  SerializableJSON.swift
//  460Demo
//
//  Created by Robert Ko on 2/8/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

/*
    Any class that is to be sent over the network should inheriet from this class so it can
    be serialized into JSON
*/
class SerializableJSON: NSObject {
    
    /*
        Convert object to a dictionary of properties.
        Eg. if self = Warrior, we have a dictionary that looks something like:
            {
                "unitType": "Warrior"
                "name": "warrior1"
                "health": 100
                "speed": 1.1
            }
    */
    func toJSONDict() -> [String: AnyObject] {
        var output_dict: [String: AnyObject] = [:]
        
        if self is Unit {
            var name = (self as Unit).name
            var health = (self as Unit).health
            var speed = (self as Unit).speed
            var unitType: String = ""
            var posX = Float((self as Unit).sprite.position.x)
            var posY = Float((self as Unit).sprite.position.y)
            if self is Warrior {
                unitType = "Warrior"
            }
            output_dict["unitType"] = unitType
            output_dict["name"] = name
            output_dict["health"] = health
            output_dict["speed"] = Float(speed)
            output_dict["posX"] = posX
            output_dict["posY"] = posY
            
        }
        else if self is Move {
            var orderType = (self as Move).type
            var pos_x = (self as Move).moveToLoc.x
            var pos_y = (self as Move).moveToLoc.y
            var receiver = (self as Move).receiver.name
            output_dict["receiver"] = receiver
            output_dict["orderType"] = orderType
            output_dict["x"] = pos_x
            output_dict["y"] = pos_y
        }
        else if self is Attack {
            var orderType = (self as Attack).type
            var receiver = (self as Attack).receiver.name
            var target = (self as Attack).target.name
            output_dict["receiver"] = receiver
            output_dict["orderType"] = orderType
            output_dict["target"] = target
        }
        return output_dict
    }
    
}