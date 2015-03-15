//
//  TextureLoader.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

class TextureLoader {
    
    var preloaded = false
    
    let Mage: SKTextureAtlas = SKTextureAtlas(named:"Mage")
    let Warrior: SKTextureAtlas = SKTextureAtlas(named:"Warrior")
    
    class var global:TextureLoader{
        struct Static{
            static var instance:TextureLoader?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            Static.instance = TextureLoader()
        }
        return Static.instance!
    }
    

    /*Call to start preloading texture atlases. Will set preloaded to true on completion*/
    func preload(){
        SKTextureAtlas.preloadTextureAtlases([Warrior, Mage], withCompletionHandler: {
            self.preloaded = true
        })
    }
    
}