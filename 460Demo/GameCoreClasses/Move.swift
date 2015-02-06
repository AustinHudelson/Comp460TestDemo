//
//  File.swift
//  460Demo
//
//  Created by Olyver on 2/2/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Move : Order
{
    var position: CGPoint
    
    init(position1: CGPoint)
    {
        position = position1
    }
    init(positionString:String)
    {
        //println(positionString)
        var temp = positionString.stringByReplacingOccurrencesOfString("\\(", withString: "{", options: .RegularExpressionSearch).stringByReplacingOccurrencesOfString("\\)", withString: "}", options: .RegularExpressionSearch) as String
        //println(temp)
        position = CGPointFromString(temp)
    }
    override var description: String {
        return "\(position)"
    }
    
    
    
}