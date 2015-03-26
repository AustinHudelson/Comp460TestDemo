//
//  Attack.swift
//  460Demo
//
//  Created by Olyver on 2/4/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

@objc(Attack)
class Attack: Order, PType
{
    var DS_target: Unit?
    var animationGapDistance: CGFloat = 20.0
    var tID: String = ""
    //var ID: String = ""
    var DS_moveState = false
    var DS_targetCircle: SKSpriteNode?
    
    init(receiverIn: Unit, target: Unit){
        super.init()
        self.DS_receiver = receiverIn
        self.DS_target = target
        self.animationGapDistance = 20.0
        tID = target.ID
        ID = receiverIn.ID
        type = "Attack"
    }

    required init(receivedData: Dictionary<String, AnyObject>) {
        super.init(receivedData: receivedData)
        restoreProperties(Attack.self, receivedData: receivedData)
        DS_receiver = Game.global.getUnit(self.ID!)
        DS_target = Game.global.getUnit(tID)
    }
    
    override func apply(){
        //Dont apply this if we cannot confirm the target and receiver were restored correctly
        if (DS_target != nil && DS_receiver != nil){
            DS_receiver!.attack(DS_target!, complete:{self.DS_receiver!.sendOrder(Idle(receiverIn: self.DS_receiver!))})
        } else {
            self.DS_receiver?.sendOrder(Idle(receiverIn: self.DS_receiver!))
            return
        }
        //Apply a red circle under the target
        if (DS_receiver!.isLocalPlayer()){
            DS_targetCircle = SKSpriteNode(imageNamed: "Selection Circle Red heavy")
            let yOffset = (-0.26 * DS_target!.sprite.size.height)
            let xyRatio: CGFloat = 2.25     /*Value calcuated xSize/ySize of the circle image*/
            let xSize = 0.5 * DS_target!.sprite.size.width
            let ySize = xSize/xyRatio
            DS_targetCircle!.size = CGSize(width: xSize, height: ySize)
            DS_targetCircle!.position = CGPoint(x: 0.0, y: yOffset)
            DS_targetCircle!.zPosition = DS_target!.sprite.zPosition-5.0
            DS_target?.sprite.addChild(DS_targetCircle!)
        }
        
    }
    
    override func remove(){
        //Remove the red circle under the target
        if (DS_receiver != nil && DS_receiver!.isLocalPlayer()){
            DS_targetCircle?.removeFromParent()
        }
        DS_receiver?.clearAttack()
    }
}
