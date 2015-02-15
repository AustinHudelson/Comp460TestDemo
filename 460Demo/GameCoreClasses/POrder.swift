//
//  POrder.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/14/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//
protocol POrder
{
    var type: String { get }
    
    func apply()
    
    func remove()
    
    func update()
}
