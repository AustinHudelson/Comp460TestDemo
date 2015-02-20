//
//  SerializableJSON.swift
//  460Demo
//
//  Created by Robert Ko on 2/8/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

/*
    REF: http://stackoverflow.com/questions/24051904/how-do-you-add-a-dictionary-of-items-into-another-dictionary
    - Used to concatenate two dictionaries
*/
func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}

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
        REF:
        https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html
        https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/WritingSwiftClassesWithObjective-CBehavior.html
        https://gist.github.com/turowicz/e7746a9c035356f9483d
        http://blog.mailcloud.com/technology/apple-swift-code-strong-type-object-serialization-to-json/
        http://stackoverflow.com/questions/25476740/how-can-i-test-if-an-instance-is-a-specific-class-or-type-in-swift
    */
    func toJSON() -> [String: AnyObject] {
        var aClass: AnyClass? = self.dynamicType
        var superClass: AnyClass! = class_getSuperclass(aClass)
        var propertiesDictionary: [String: AnyObject] = [:]
        
        // Get this class's properties & put it in our results dictionary
        var classPropertiesDict = toDictionary(aClass)
        propertiesDictionary += classPropertiesDict
        
        /*
            - if this obj's superclass is a specific class (eg. Unit, Order...etc), then get that super class's properties too. We're only doing this check because sometimes we might get an Object whose superclass is not the class we're expecting (eg. NSObject), and we don't really want to serialize those superclass's properties
        */
        if superClass === Unit.self || superClass === Order.self {
            var superClassPropertiesDict = toDictionary(superClass)
            // Put the superClass's properties in our results dictionary
            propertiesDictionary += superClassPropertiesDict
        }
        return propertiesDictionary
    }
    
    /*
        - This method should only be used by toJSON() above when you need to convert a class's (and its super class's)
        properties into a dictionary
    */
    func toDictionary(aClass: AnyClass?) -> [String: AnyObject] {
        var propertiesCount: CUnsignedInt = 0
        var propertiesInAClass: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        var propertiesDictionary: [String: AnyObject] = [:]
        
        for var i = 0; i < Int(propertiesCount); i++ {
            var property = propertiesInAClass[i]
            var propName = String.fromCString(property_getName(property))!
            var propType = property_getAttributes(property)
            var propValue : AnyObject! = self.valueForKey(propName);
            
            /*
                - If this property's name is tagged with "DS_" (Don't Send), ignore it
            */
            if propValue is SerializableJSON {
                /*
                    - This if statement recursively calls toJSONDict() when this particular property's value is itself a subclass
                    of SerializableJSON
                    - So for example, when you get a property that looks like this within a class:
                    var order: Order
                    you would basically recursively call order.toJSONDict()
                */
                propertiesDictionary[propName] = (propValue as SerializableJSON).toJSON()
            } else if propValue is Array<SerializableJSON> {
                /*
                    - if this particular property's value is an array, serialize this array recursively
                */
                var subArray = Array<AnyObject>()
                for item in (propValue as Array<SerializableJSON>) {
                    subArray.append(item.toJSON())
                }
                propertiesDictionary[propName] = subArray
            } else {
                if !(propValue is SKSpriteNode) {
                    propertiesDictionary[propName] = propValue
                }
            }
        }
        
        propertiesInAClass.dealloc(Int(propertiesCount))
        return propertiesDictionary
    }
    
}