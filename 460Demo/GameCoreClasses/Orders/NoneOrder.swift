//
//  None.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

@objc(NoneOrder)
class NoneOrder: Order, PType {
    //Dummy order that does nothing
    override init(){
        super.init()
        self.type = "NoneOrder"
    }

    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
    }
}