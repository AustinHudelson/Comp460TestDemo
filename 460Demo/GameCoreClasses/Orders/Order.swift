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
@objc(Order)
class Order: SerializableJSON, PType
{
    var type: String = "UNDEFINED"
    var DS_receiver: Unit?
    var ID: String?
    
    required init(receivedData: Dictionary<String, AnyObject>){
        super.init(receivedData: receivedData)
        //Leave empty as there are no types in this class
        restoreProperties(Order.self, receivedData: receivedData)
    }
    
    override init(){
        super.init()
        //IN ALL SUBCLASSES INIT MUST INITIALIZE TYPE
    }
    
    /*
     * Called when a unit is sent a new order. of the
     * unit is not undated until AFTER apply has been run.
     * you can reference the last order by self.DS_receiver.order
     * in this function
     */
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
