//
//  Order.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//


//ORDER CLASS
//Should be treated like a java "Abstract class" for orders 
//that conform to the "Interface" (swift "Protocall") POrder
class Order: SerializableJSON, PType
{
    var type: String {
        return "UNDEFINED"
    }
    
    func apply(){
        //Print error message
    }
    
    func remove(){
        //Print error message
    }
    
    func update(){
        //Print error message
    }
}
