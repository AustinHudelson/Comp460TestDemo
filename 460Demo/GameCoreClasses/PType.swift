//
//  POrder.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/14/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

//Protocol for an object with a "Type" field. Should be used to lookup the class of an object from the type string.
//WARNING: Subclasses of PType MUST set this string in their constructor!
protocol PType
{
    var type: String { get set }
}
