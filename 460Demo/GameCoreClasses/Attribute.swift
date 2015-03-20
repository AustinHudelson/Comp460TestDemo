//
//  Attribute.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/18/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//
//  Attribute is a easially modifiable CGFloat. Is serializeable.

import Foundation

@objc(Attribute)
class Attribute: SerializableJSON {
    
    var type: String = "Attribute"
    var b: CGFloat = 0.0
    var m: [String: CGFloat] = [:]
    var DS_update = true
    var DS_store: CGFloat = 0.0
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init()
        restoreProperties(Attribute.self, receivedData: receivedData)
    }
    
    /* baseValue should be the default unmodified value*/
    init(baseValue: CGFloat){
        super.init()
        b = baseValue
    }
    
    /*
     *  returns the modified value of the Attribute. Will recalculate and cache the value if it has been
     *  modified since the last .get()
     */
    func get()->CGFloat {
        if DS_update == true {
            DS_store = b
            for (key, value) in m {
                DS_store = DS_store * value
            }
        }
        DS_update = false
        return DS_store
    }
    
    /*
     *  ADDS A MULTIPLICITIVE. Multiplier to the base value. when calculating the final modified value the
     *  attribute takes the product of the base value and all modifiers. Addins a second modifier with
     *  the same key as the first modifier will replace the old modifier.
     */
    func addModifier(key: String, value: CGFloat) {
        m[key] = value
        DS_update = true
    }
    
    /*
     *  Removes a modifier with a specified key.
     */
    func removeModifier(key: String) {
        m[key] = nil
        DS_update = true
    }
    
}