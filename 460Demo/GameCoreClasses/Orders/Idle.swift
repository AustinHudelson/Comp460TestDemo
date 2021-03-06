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
    
    //var DS_receiver: Unit
    
    init (receiverIn: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.type = "Idle"
    }

    required init(receivedData: Dictionary<String, AnyObject>) {
        fatalError("init(receivedData:) has not been implemented: Idle being sent over network?")
    }
}