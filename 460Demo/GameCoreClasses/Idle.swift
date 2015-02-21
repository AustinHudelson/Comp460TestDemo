//
//  Idle.swift
//  460Demo
//
//  Created by Robert Ko on 2/13/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

/*
    This Order is what a unit does if it's standing around
    - For now, there's nothing, but maybe later on we can add an idle animation
*/
@objc(Idle)
class Idle: Order, PType {
    
    var receiver: Unit
    
    init (receiverIn: Unit){
        self.receiver = receiverIn
        super.init()
        type = "Idle"
    }

    required init(receivedData: Dictionary<String, AnyObject>, unitList:Dictionary<String, Unit>) {
        fatalError("init(receivedData:) has not been implemented")
    }
    
}