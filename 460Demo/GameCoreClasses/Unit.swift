//
//  Unit.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation
@objc(Unit)
class Unit: SerializableJSON, PType
{
//    var UnitCategory: UInt32 = 0x1 << 0
//    var name: String = ""
    var type: String = "Unit"
    var ID: String = ""
    var health: Int = 0
    var maxhealth: Int = 0
    var healthregen: Int = 0
    var speed: CGFloat = 0.0
    var sprite: SKNode = SKSpriteNode(imageNamed: "Mage")
    var currentOrder: Order = NoneOrder()
    var alive: Bool = true
    var DS_walkAnim: SKAction?
    var DS_attackAnim: SKAction?
    var DS_standAnim: SKAction?
    var isEnemy: Bool = true
    
    var DS_health_txt: SKLabelNode = SKLabelNode(text: "")
    var health_txt_y_dspl: CGFloat = 40 // The y displacement of health text relative to this unit's sprite
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init()
        
        restoreProperties(Unit.self, receivedData: receivedData)
        
        /* Configure Health Text (SHOULD MATH OTHER INIT() FUNCTION) */
        self.DS_health_txt.fontColor = UIColor.redColor()
        self.DS_health_txt.text = self.health.description
        self.DS_health_txt.fontSize = 40
        
//        // physics stuff
//        self.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.sprite.frame.size)
//        self.sprite.physicsBody?.usesPreciseCollisionDetection = true
//        self.sprite.physicsBody?.categoryBitMask = UnitCategory
//        self.sprite.physicsBody?.collisionBitMask = 0
//        self.sprite.physicsBody?.contactTestBitMask = UnitCategory
    }
    
    init(ID: String, spawnLocation: CGPoint) {
        super.init()
        self.ID = ID
        self.currentOrder = NoneOrder()
        /* Configure our health text */
        self.DS_health_txt.fontColor = UIColor.redColor()
        self.DS_health_txt.text = self.health.description
        self.DS_health_txt.fontSize = 40
        
//        //// physics stuff
//        self.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.sprite.frame.size)
//        self.sprite.physicsBody?.usesPreciseCollisionDetection = true
//        self.sprite.physicsBody?.categoryBitMask = UnitCategory
//        self.sprite.physicsBody?.collisionBitMask = 0
//        self.sprite.physicsBody?.contactTestBitMask = UnitCategory
//        //self.sprite.physicsBody?.restitution = 0
//        //self.sprite.physicsBody?.
        
        
        
    }
    
    
    
    /*
        Used to add a unit to the game scene at position 'pos', with sprite.xScale = 'scaleX' & sprite.yScale = 'scaleY'.
        Also displays a health text on top of this unit
    */
    func addUnitToGameScene(gameScene: GameScene, pos: CGPoint)
    {
        self.sprite.position = pos
        gameScene.addChild(self.sprite)
        
        /* Add health text */
        var health_txt_pos: CGPoint = pos
        health_txt_pos.y += self.health_txt_y_dspl
        self.DS_health_txt.position = health_txt_pos
        gameScene.addChild(self.DS_health_txt)
        
        //PRINTLN MYSELF AS JSON
        //println("PRINTING SELF AS JSON LOOK HERE!!!!")
        //println(self.toJSON())
        
    }
    
    func sendOrder(order: Order){
        //println("hi")
        //println(order.type)
        currentOrder.remove()
        currentOrder = order
        currentOrder.apply()
    }
    
    func takeDamage(damage:Int)
    {
        health-=damage
        
        if health < 0 {
            health = 0
            death()
        }
        
        //println("\(ID), \(health)")
        self.DS_health_txt.text = self.health.description
    }
    
    func faceLeft(){
        self.sprite.runAction(SKAction.scaleXTo(-0.5, duration: 0.0))
    }
    
    func faceRight(){
        self.sprite.runAction(SKAction.scaleXTo(0.5, duration: 0.0))
    }
    
    func applyTint(tint: SKColor, factor: CGFloat, blendDuration: NSTimeInterval){
        let changeColorAction = SKAction.colorizeWithColor(tint, colorBlendFactor: factor, duration: blendDuration)
        self.sprite.runAction(changeColorAction) {
            (self.sprite as SKSpriteNode).color = tint //On completion of action, we set color so after in comparison method not have conflicts while comparing color components
        }
    }
    
    func isLocalPlayer() -> Bool{
        if self.ID == AppWarpHelper.sharedInstance.playerName {
            return true
        }
        return false
    }
    
    func move(destination:CGPoint, complete:(()->Void)!)
    {
        let charPos = sprite.position
        let xdif = destination.x-charPos.x
        let ydif = destination.y-charPos.y
        
        //Check facing
        if (xdif < -0.1) {
            self.faceLeft()
        } else if (xdif > 0.1) {
            self.faceRight()
        }
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/speed
        let movementAction = SKAction.moveTo(destination, duration:NSTimeInterval(duration))
        let walkAnimationAction = self.DS_walkAnim
        //Create action for "Walk to point then do "complete""
        let walkSequence = SKAction.sequence([movementAction, SKAction.runBlock(complete)])
        /* Move the health text */
        var health_txt_des = destination
        
        health_txt_des.y += health_txt_y_dspl
        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
        DS_health_txt.runAction(moveHealthTxtAction, withKey: "move")
        sprite.runAction(walkSequence, withKey: "move")
        sprite.runAction(self.DS_walkAnim!, withKey: "moveAnim")
    }
    
    func clearMove(){
        self.sprite.removeActionForKey("move")
        self.sprite.removeActionForKey("moveAnim")
        self.DS_health_txt.removeActionForKey("move")
    }
    
    func attack(target: Unit){
        
    }
    
    func attackCycle(target: Unit){
        let tolerence = CGFloat(20.0)
        let animationGapDistance: CGFloat = 20.0 //Default value is overwritten in init
        
        if target.alive == true         //ENSURE ATTACK IS STILL VALID
        {
            var movePos: CGPoint
            if(self.sprite.position.x < target.sprite.position.x)
            {
                movePos = CGPoint(x: target.sprite.frame.minX-animationGapDistance, y: target.sprite.frame.midY)
            }
            else
            {
                movePos = CGPoint(x: target.sprite.frame.maxX-1+animationGapDistance,y : target.sprite.frame.midY)
            }
            
            if Game.global.getDistance(self.sprite.position, p2: movePos) > tolerence {
                self.move(movePos, complete:{
                    self.clearMove()
                    self.attackCycle(target)
                })
            } else {
                if self.sprite.position.x < target.sprite.position.x {
                    self.faceRight()
                } else {
                    self.faceLeft()
                }
                self.sprite.runAction(self.DS_attackAnim!, withKey: "AttackAnim")
                let delay = SKAction.waitForDuration(1.0)
                self.sprite.runAction(delay, completion: {
                        self.attackCycle(target)
                    })
                target.takeDamage(3)
            }
        }
    }
    
    func clearAttack(){
        
    }
    
    /*
    * Call the synchronize this unit with the host. Will correct current life and 
    * position if it has deviated too far from the host.
    */
    func synchronize(syncTime: NSTimeInterval, recievedLife: Int, recievedPosition: CGPoint){
        
    }
    
    /*
     * Call every 1 second or so to update units.
     */
    func update(){
        /*
         * AUTOMATIC LIFE REGEN
         */
        
        if self.health < self.maxhealth{
            self.takeDamage(-self.healthregen)
        }
        
        //self.currentOrder.update()
    }
    
    /*
    * LOCAL DEATH
    * playes the units death animation and prevents further actions
    */
    func death(){
        if alive == false {
            return
        }
        alive = false
        applyTint(SKColor.blackColor(), factor: 1.0, blendDuration: 1.0)
        sendOrder(Idle(receiverIn: self))
        
        Game.global.removeUnit(ID) //REMOVE UNIT LOCALLY: (DANGEROUS)
    }
    
    /*
    * Actually removes the unit from memory. Should not be called until a negitive update unit is called
    */
    func kill(){
        
    }
    
    
    
}
