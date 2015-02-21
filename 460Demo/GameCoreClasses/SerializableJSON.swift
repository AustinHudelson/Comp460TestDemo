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
public class SerializableJSON: NSObject {
    
    
    
    /*
    - A method that is shared between toJSON() and fromJSON()
    - This method returns an array of properties in the given class
    */
    public func toJSONDict() -> [String: AnyObject] {
        var output_dict: [String: AnyObject] = [:]
        
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
