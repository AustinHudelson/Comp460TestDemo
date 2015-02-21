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
public class SerializableJSON: NSObject {
    
    
    
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
    public func toJSONDict() -> [String: AnyObject] {
        var output_dict: [String: AnyObject] = [:]
        
        if self is Unit {
            var name = (self as Unit).name
            var health = (self as Unit).health
            var speed = (self as Unit).speed
            let ID = (self as Unit).ID
            var unitType: String = ""
            var posX = Float((self as Unit).sprite.position.x)
            var posY = Float((self as Unit).sprite.position.y)
            if self is Warrior {
                unitType = "Warrior"
            }
            output_dict["unitType"] = unitType
            output_dict["name"] = name
            output_dict["ID"] = ID
            output_dict["health"] = health
            output_dict["speed"] = Float(speed)
            output_dict["posX"] = posX
            output_dict["posY"] = posY
            
        }
        else if self is Move {
            var orderType = (self as Move).type
            var pos_x = (self as Move).moveToLoc.x
            var pos_y = (self as Move).moveToLoc.y
            var receiver = (self as Move).receiver.ID
            output_dict["receiver"] = receiver
            output_dict["orderType"] = orderType
            output_dict["x"] = pos_x
            output_dict["y"] = pos_y
        }
        else if self is Attack {
            var orderType = (self as Attack).type
            var receiver = (self as Attack).receiver.ID
            var target = (self as Attack).target.ID
            output_dict["receiver"] = receiver
            output_dict["orderType"] = orderType
            output_dict["target"] = target
        }
        return output_dict
    }
    
    public func toDictionary() -> NSDictionary {
        var aClass : AnyClass? = self.dynamicType
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        var propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
        
        for var i = 0; i < Int(propertiesCount); i++ {
            var property = propertiesInAClass[i]
            var propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            var propType = property_getAttributes(property)
            var propValue : AnyObject! = self.valueForKey(propName);
            
            //if (propName == "currentOrder" || propName == "sprite" || propName == "health_txt"){
            //    continue
            //}
            
            println(propName)
            
            if propValue is SerializableJSON {
                propertiesDictionary.setValue((propValue as SerializableJSON).toDictionary(), forKey: propName)
            } else if propValue is Array<SerializableJSON> {
                var subArray = Array<NSDictionary>()
                for item in (propValue as Array<SerializableJSON>) {
                    subArray.append(item.toDictionary())
                }
                propertiesDictionary.setValue(subArray, forKey: propName)
            } else if propValue is NSData {
                propertiesDictionary.setValue((propValue as NSData).base64EncodedStringWithOptions(nil), forKey: propName)
            } else if propValue is Bool {
                propertiesDictionary.setValue((propValue as Bool).boolValue, forKey: propName)
            } else {
                //println("Cannot Serialize "+propName)
                propertiesDictionary.setValue(propValue, forKey: propName)
            }
        }
        println("DONE1")
        // class_copyPropertyList retaints all the
        propertiesInAClass.dealloc(Int(propertiesCount))
        
        return propertiesDictionary
    }
    
    public func toJson() -> NSData! {
        var dictionary = self.toDictionary()
        println(dictionary)
        var err: NSError?
        return NSJSONSerialization.dataWithJSONObject(dictionary, options:NSJSONWritingOptions(0), error: &err)
    }
    
    public func toJsonString() -> NSString! {
        println("DONE2")
        let ret = NSString(data: self.toJson(), encoding: NSUTF8StringEncoding)
        println("DONE3")
        return ret
    }
    
    
}