//
//  GameData.swift
//  460Demo
//
//  Created by Robert Ko on 4/1/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

/*
    A global object that stores data that needs to be saved to a local file
    - This object's data should be initilized through FileManager.loadGameData()
    - This object's data should be saved through FileManager.saveGameData()
*/
class PersistGameData: NSObject, NSCoding, Printable {
    var myPlayerName: String = ""
    
    class var sharedInstance: PersistGameData {
        struct Static{
            static var instance: PersistGameData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            Static.instance = PersistGameData()
        }
        return Static.instance!
    }
    
    override var description: String {
        get {
            let outStr = "myPlayerName: \(myPlayerName)\n"
            return outStr
        }
    }

    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.myPlayerName, forKey: "myPlayerName")
    }
    
    required init(coder: NSCoder) {
        self.myPlayerName = coder.decodeObjectForKey("myPlayerName") as String;
        super.init()
    }
    
    override init() {
        super.init()
    }
}