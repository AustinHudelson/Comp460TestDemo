//
//  Taunt.swift
//  460Demo
//
//  Created by Robert Ko on 3/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

@objc(Taunt)
class Taunt: Order, PType
{
    var DS_tauntedEnemy: Unit? = nil
    
    init(receiverIn: Unit)
    {
        super.init()
        self.DS_receiver = receiverIn
        self.ID = receiverIn.ID
        self.type = "Taunt"
        
    }
    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        self.restoreProperties(Taunt.self, receivedData: receivedData)
        
        self.DS_receiver = Game.global.getUnit(ID!)
        
            }
    
    override func apply()
    {
        
        self.taunt()
        println("\(self.DS_receiver!.ID) taunted: \(DS_tauntedEnemy?.ID)")
        
        if DS_tauntedEnemy != nil{
        (DS_tauntedEnemy!.currentOrder as RoamAttack).redirect(self.DS_receiver!)
        }
        
    }
    
    func taunt()
    {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in Game.global.enemyMap {
            if unit.alive == false {
                continue
            }
            if (unit.currentOrder as RoamAttack).DS_target?.ID == self.DS_receiver!.ID
            {
                continue
            }
            var p2 = unit.sprite.position
            var dist = Game.global.getRelativeDistance(DS_receiver!.sprite.position, p2:p2)
            if dist < near{
                nearby = unit
                near = dist
            }
        }
        DS_tauntedEnemy = nearby;
        
        
        
       
    }
    
    
  
            
            
}