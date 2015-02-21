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

class SerializableJSON: NSObject {
    
    /*
    - A method that is shared between toJSON() and fromJSON()
    - This method returns an array of properties in the given class
    */
    func propertyNames(aClass: AnyClass?) -> [String] {
        var propNames: [String] = []
        var propertiesCount: CUnsignedInt = 0
        var propertiesInAClass: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        
        for var i = 0; i < Int(propertiesCount); i++ {
            var property = propertiesInAClass[i]
            var propName = String.fromCString(property_getName(property))!
            propNames.append(propName)
        }
        free(propertiesInAClass)
        return propNames
    }
    
    /*
    ===============================================================================
    METHODS USED TO CONVERT THIS OBJECT TO A DICTIONARY ENTRY IN JSON
    REF:
    https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html
    https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/WritingSwiftClassesWithObjective-CBehavior.html
    https://gist.github.com/turowicz/e7746a9c035356f9483d
    http://blog.mailcloud.com/technology/apple-swift-code-strong-type-object-serialization-to-json/
    http://stackoverflow.com/questions/25476740/how-can-i-test-if-an-instance-is-a-specific-class-or-type-in-swift
    http://stackoverflow.com/questions/26630447/serializing-custom-bag-object-to-json-string-int-to-bool-in-swift
    
    - This method goes through this object's properties and serialize it into a JSON dictionary
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
        
        
        var propertiesDictionary: [String: AnyObject] = [:]
        
        for propName in propertyNames(aClass) {
            //            var propType = property_getAttributes(property)
            var propValue : AnyObject! = self.valueForKey(propName);
            
            /*
            - If this property's name contains the substring "DS_" (Don't Send), ignore it
            REF: http://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift
            */
            if propName.rangeOfString("DS_") != nil {
                continue
            }
            
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
            } else if (propValue is SKSpriteNode) {
                /*
                - Convert generally unserializable propValues, such as SKSpriteNode, into NSData and store it as an encoded string in the JSON file
                */
//                let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(propValue)
//                propertiesDictionary[propName] = data.base64EncodedStringWithOptions(nil)
            } else if (propValue is SKLabelNode || propValue is SKAction) {
                // skip
            } else {
                propertiesDictionary[propName] = propValue
            }
        }
        
        return propertiesDictionary
    }
}
