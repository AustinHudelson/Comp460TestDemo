//
//  Attribute.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/18/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

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
    
    init(baseValue: CGFloat){
        super.init()
        b = baseValue
    }
    
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
    
    func addModifier(key: String, value: CGFloat) {
        m[key] = value
        DS_update = true
    }
    
    func removeModifier(key: String) {
        m[key] = nil
        DS_update = true
    }
    
}