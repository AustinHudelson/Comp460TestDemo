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
    var xSize: CGFloat = 200.0
    var ySize: CGFloat = 200.0
    var attackRange: CGFloat = 20.0
    var attackSpeed: NSTimeInterval = NSTimeInterval(3.0)
    var sprite: SKNode = SKSpriteNode(imageNamed: "Mage")
    var currentOrder: Order = NoneOrder()
    var alive: Bool = true
    var DS_walkAnim: SKAction?
    var DS_attackAnim: SKAction?
    var DS_standAnim: SKAction?
    var DS_deathAnim: SKAction?
    var DS_stumbleAnim: SKAction?
    var DS_abilityAnim: SKAction?
    var isEnemy: Bool = true
    //var isMoving: Bool = false
    var isAttacking: Bool = false
    
    var DS_health_txt: SKLabelNode = SKLabelNode(text: "")
    var health_txt_y_dspl: CGFloat = 70 // The y displacement of health text relative to this unit's sprite
    
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
        println(order.type)
        if order is Transient {
            println("Running transient ability")
            order.apply()
            order.remove()
            return
        }
        currentOrder.remove()
        currentOrder = order
        order.apply()
    }
    
    func takeDamage(damage:Int)
    {
        
        health-=damage
        if health>maxhealth
        {
            health=maxhealth
        }
        
        
        
        if health < 0 {
            health = 0
            death()
        } else {
            if damage > 0 {
                self.sprite.runAction(DS_stumbleAnim)
            }
        }
        
        //println("\(ID), \(health)")
        self.DS_health_txt.text = self.health.description
    }
    
    func faceLeft(){
        self.sprite.runAction(SKAction.scaleXTo(-1.0, duration: 0.0))
    }
    
    func faceRight(){
        self.sprite.runAction(SKAction.scaleXTo(1.0, duration: 0.0))
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
    
    func attack(target: Unit, complete:(()->Void)!){
        clearAttack()
        attackCycle(target, complete)
    }
    
    /*
     * Recursive function that calls itself to make this unit move in to range and attack
     * target. If the target is not in range, then a small move command is called. If the target
     * is within range then an attack animation is played. If the target is no longer valid then
     * complete parameter block is called. This cycle can be interupted by calling clearAttack()
     * or clearMove() if the unit is in the process of moving to the attack target.
     */
    func attackCycle(target: Unit, complete:(()->Void)!){
        let tolerence = attackRange
        let animationGapDistance: CGFloat = 20.0 //Default value is overwritten in init
        let refreshRate: CGFloat = 0.5
        
        if target.alive == true{         //ENSURE ATTACK IS STILL VALID
            
            /* Determine move position */
            var movePos: CGPoint
            if(self.sprite.position.x < target.sprite.position.x){
                movePos = CGPoint(x: target.sprite.frame.minX-animationGapDistance, y: target.sprite.frame.midY)
            }else{
                movePos = CGPoint(x: target.sprite.frame.maxX-1+animationGapDistance,y : target.sprite.frame.midY)
            }
            
            
            if Game.global.getDistance(self.sprite.position, p2: movePos) > tolerence {
                //Move a short distance towards the movePos. Dont move more than the distance to the move pos (hence the min function for distance). And call attack cycle again once the move is complete.
                let adjustedMove: CGPoint = Game.global.getPointOffsetTowardPoint(self.sprite.position, p2:movePos, distance: min(self.speed*refreshRate, Game.global.getDistance(self.sprite.position, p2:movePos)))
                self.move(adjustedMove, complete:{
                    self.attackCycle(target, complete: complete)
                })
            } else {
                if self.sprite.position.x < target.sprite.position.x {
                    self.faceRight()
                } else {
                    self.faceLeft()
                }
                
                let delay = SKAction.waitForDuration(attackSpeed)
                let completeBlock = SKAction.runBlock({
                    self.attackCycle(target, complete: complete)
                })
                let attackSequence = SKAction.sequence([delay, completeBlock])
                self.sprite.runAction(attackSequence, withKey: "attack")
                self.sprite.runAction(self.DS_attackAnim!, withKey: "attackAnim")
                target.takeDamage(3)
            }
        } else {
            //target is invalid. call the complete block.
            self.sprite.runAction(SKAction.runBlock(complete))
        }
    }
    
    func clearAttack(){
        clearMove()
        self.sprite.removeActionForKey("attack")
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
        //applyTint(SKColor.blackColor(), factor: 1.0, blendDuration: 1.0)
        sendOrder(Idle(receiverIn: self))
        self.sprite.removeActionForKey("stand")
        //SETUP DEATH SEQUENCE! Play Death. Wait. Then remove. REMOVING LOCALLY IS DANGEROUS
        let waitAction: SKAction = SKAction.waitForDuration(NSTimeInterval(0.0))
        let removeBlockAction:SKAction = SKAction.runBlock({
            Game.global.removeUnit(self.ID)
        })
        let deathThenRemove: SKAction = SKAction.sequence([DS_deathAnim!, waitAction, removeBlockAction])
        self.sprite.runAction(deathThenRemove)
    }
    
    /*
    * Actually removes the unit from memory. Should not be called until a negitive update unit is called
    */
    func kill(){
        
    }
    
    
    
}
