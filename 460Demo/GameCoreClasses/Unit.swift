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
    var health: CGFloat = 0.0
    var damageMultiplier: Attribute = Attribute(baseValue: 1.0)
    var maxhealth: Attribute = Attribute(baseValue: 0.0)
    var healthregen: Int = 0
    var speed: Attribute = Attribute(baseValue: 0.0)
    var xSize: CGFloat = 200.0
    var ySize: CGFloat = 200.0
    var attackRange: CGFloat = 20.0
    var attackSpeed: Attribute = Attribute(baseValue: 3.0)
    var attackDamage: Attribute = Attribute(baseValue: 3.0)
    var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "WarriorStand350x350")
    var redColor: Attribute = Attribute(baseValue: 1.0)
    var blueColor: Attribute = Attribute(baseValue: 1.0)
    var greenColor: Attribute = Attribute(baseValue: 1.0)
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
    var DS_attackTarget: Unit?
    var DS_isCommandable: Bool = true   /*Private*/
    var DS_queuedOrder: Order?
    
    var DS_health_txt: SKLabelNode = SKLabelNode(text: "")
    var DS_health_bar: SKSpriteNode = SKSpriteNode(imageNamed: "health_bar_green")
    
    var health_txt_y_dspl: CGFloat = 100 // The y displacement of health text relative to this unit's sprite
    var health_bar_x_dspl: CGFloat = 35
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init()
        
        restoreProperties(Unit.self, receivedData: receivedData)
        
        /* Configure Health Text (SHOULD MATH OTHER INIT() FUNCTION) */
        self.DS_health_txt.fontColor = UIColor.greenColor()
        self.DS_health_txt.text = self.health.description
        self.DS_health_txt.fontName = "AvenirNext-Bold"
        self.DS_health_txt.fontSize = 40
        // ===TESTING
        var barSize: CGSize = CGSize(width: CGFloat(100), height: CGFloat(25))
        self.DS_health_bar.size = barSize
        
        self.sprite.anchorPoint = CGPoint(x:0, y:0)
        self.DS_health_bar.anchorPoint = CGPoint(x:0, y:0)
        self.DS_health_txt.zPosition = 2
        self.DS_health_bar.zPosition = 2
       
    }
    
    init(ID: String, spawnLocation: CGPoint) {
        super.init()
        self.ID = ID
        self.currentOrder = NoneOrder()
        /* Configure our health text */
        self.DS_health_txt.fontColor = UIColor.redColor()
        self.DS_health_txt.text = self.health.description
        self.DS_health_txt.fontSize = 40
        // ===TESTING
        self.sprite.anchorPoint = CGPoint(x:0, y:0)
        self.DS_health_bar.anchorPoint = CGPoint(x:0, y:0)
        self.DS_health_txt.zPosition = 2
        self.DS_health_bar.zPosition = 2
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
        
        var health_bar_pos: CGPoint = pos
        health_bar_pos.y += self.health_txt_y_dspl
        health_bar_pos.x = pos.x - health_bar_x_dspl //can't get it to work other than hard coding
        self.DS_health_bar.position = health_bar_pos
        //gameScene.addChild(self.DS_health_txt)
        gameScene.addChild(self.DS_health_bar)
        //adjustBarAnchorPoint()
        //PRINTLN MYSELF AS JSON
        //println("PRINTING SELF AS JSON LOOK HERE!!!!")
        //println(self.toJSON())
        
    }
    
    /*
    Flags a unit as uncommandable. Causes all orders to be ignored
    except the last order sent before makeCommandable() is called.
    */
    func makeUncommandable(){
        self.DS_isCommandable = false
    }
    
    /*
    Revokes the previous makeUncommandable call.
    Allows orders to be sent to this unit and if an
    order was attempted to be sent to this unit then
    the last sent order will be applied.
    */
    func makeCommandable(){
        self.DS_isCommandable = true
        if (self.DS_queuedOrder != nil) {
            sendOrder(DS_queuedOrder!)
            DS_queuedOrder = nil
        }
    }
    
    func sendOrder(order: Order){
        if self.DS_isCommandable {
            if order is Transient {
                println("Running transient ability")
                order.apply()
                order.remove()
                return
            }
            currentOrder.remove()
            currentOrder = order
            order.apply()
        } else {
            //If this unit is uncommandable queue the order instead
            self.DS_queuedOrder = order
        }
    }
    
    func dealDamage(damage: CGFloat, target: Unit){
        target.takeDamage(damage)
    }
    
    func takeDamage(damage:CGFloat)
    {
        
        health -= self.damageMultiplier.get() *  damage
        if health > maxhealth.get()
        {
            health=maxhealth.get()
        }
        
        
        
        if health <= 0 {
            health = 0
            death()
        } else {
            if self.sprite.actionForKey("attackAnim") == nil && damage > 0{
                println("taking damage")
                self.sprite.runAction(DS_stumbleAnim)
            }
        }
        
        //println("\(ID), \(health)")
        
        let newSize: CGSize = CGSize(width: CGFloat(self.health/self.maxhealth.get()*100), height: CGFloat(25))
        //self.DS_health_bar.runAction(SKAction.resizeToWidth(width:(self.health/self.maxhealth.get()*100)))
        self.DS_health_bar.size = newSize
        self.DS_health_bar.position = CGPoint(x:self.sprite.position.x - self.health_bar_x_dspl, y: self.sprite.position.y + health_txt_y_dspl)
        
        
    }
    
    func faceLeft(){
        self.sprite.runAction(SKAction.scaleXTo(-1.0, duration: 0.0))
    }
    
    func faceRight(){
        self.sprite.runAction(SKAction.scaleXTo(1.0, duration: 0.0))
    }
    
    /* Applies a tint to this unit. You can remove this tint modifier later by calling removeTint
     * with the provided key parameter. red blue and green should be values between 0 and 1.
     * by default tint is 1.0 1.0 1.0. So to apply a blue tint you would use colors such as
     * 0.1 1.0 0.1
     */
    func applyTint(key: String, red: CGFloat, blue: CGFloat, green: CGFloat){
        redColor.addModifier(key, value: red)
        blueColor.addModifier(key, value: blue)
        greenColor.addModifier(key, value: green)
        updateTint()
    }
    
    /*
     * Removes the tint modifier specified by key
     */
    func removeTint(key: String){
        redColor.removeModifier(key)
        blueColor.removeModifier(key)
        greenColor.removeModifier(key)
        updateTint()
    }
    
    /* Helper function for add and remove tint */
    func updateTint(){
        let color = UIColor(red: redColor.get(), green: greenColor.get(), blue: blueColor.get(), alpha: 1.0)
        let changeColorAction = SKAction.colorizeWithColor(color, colorBlendFactor: 1.0, duration: NSTimeInterval(0.5))
        self.sprite.runAction(changeColorAction) {
            (self.sprite as SKSpriteNode).color = color //On completion of action, we set color so after in comparison method not have conflicts while comparing color components
        }
    }
    
    func isLocalPlayer() -> Bool{
        if self.ID == AppWarpHelper.sharedInstance.playerName {
            return true
        }
        return false
    }
    
    func move(destination:CGPoint, complete:(()->Void)!) {
        moveCycle(destination, complete: complete)
//        let charPos = sprite.position
//        let xdif = destination.x-charPos.x
//        let ydif = destination.y-charPos.y
//        
//        //Check facing
//        if (xdif < -0.1) {
//            self.faceLeft()
//        } else if (xdif > 0.1) {
//            self.faceRight()
//        }
//        
//        let distance = sqrt((xdif*xdif)+(ydif*ydif))
//        let duration = distance/speed
//        
//        let movementAction = SKAction.moveTo(destination, duration:NSTimeInterval(duration))
//        let walkAnimationAction = self.DS_walkAnim
//        //Create action for "Walk to point then do "complete""
//        let walkSequence = SKAction.sequence([movementAction, SKAction.runBlock(complete)])
//        /* Move the health text */
//        var health_txt_des = destination
//        
//        health_txt_des.y += health_txt_y_dspl
//        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
//        DS_health_txt.runAction(moveHealthTxtAction, withKey: "move")
//        sprite.runAction(walkSequence, withKey: "move")
//        if self.sprite.actionForKey("moveAnim") == nil {
//            sprite.runAction(self.DS_walkAnim!, withKey: "moveAnim")
//        }
    }
    
    
    /*
     * Recursive function that moves the unit a short distance towards destination
     * and then calls itself again. calls complete upon reaching the destination
     */
    func moveCycle(destination: CGPoint, complete:(()->Void)!){
        let refreshRate: CGFloat = 0.25
        let maxMoveDistance: CGFloat = self.speed.get()*refreshRate
        let remainingDistance: CGFloat = Game.global.getDistance(self.sprite.position, p2: destination)
        
        var adjustedMove: CGPoint
        var duration: CGFloat
        var walkSequence: SKAction
            
        if maxMoveDistance < remainingDistance+3.0 { //Give some leway for the final move. mostly to make attack work smoother.
            //Move a short distance towards the destination.
            adjustedMove = Game.global.getPointOffsetTowardPoint(self.sprite.position, p2:destination, distance: maxMoveDistance)
            duration = maxMoveDistance/speed.get()
            let movementAction = SKAction.moveTo(adjustedMove, duration:NSTimeInterval(duration))
            //Set up move action to call move cycle again at the end
            walkSequence = SKAction.sequence([movementAction, SKAction.runBlock({self.moveCycle(destination, complete: complete)})])
        } else {
            //Move the rest of the distance to the destination
            adjustedMove = Game.global.getPointOffsetTowardPoint(self.sprite.position, p2:destination, distance: remainingDistance)
            duration = remainingDistance/speed.get()
            let movementAction = SKAction.moveTo(adjustedMove, duration:NSTimeInterval(duration))
            //Set up the move action to call complete block at the end
            walkSequence = SKAction.sequence([movementAction, SKAction.runBlock(complete)])
        }
        
        //Create movement action for health text
        var healthTextAdjustedMove = adjustedMove
        healthTextAdjustedMove.y += health_txt_y_dspl
        healthTextAdjustedMove.x -= health_bar_x_dspl
        let healthTextMovementAction = SKAction.moveTo(healthTextAdjustedMove, duration:NSTimeInterval(duration))
        
        //Start looping the walk animation if it is not already playing.
        if self.sprite.actionForKey("moveAnim") == nil {
            sprite.runAction(self.DS_walkAnim!, withKey: "moveAnim")
        }
        
        //Check facing
        if (self.sprite.position.x > destination.x+1.0) {
            self.faceLeft()
        } else if (self.sprite.position.x < destination.x-1.0) {
            self.faceRight()
        }
        
        //Apply the actions to the health text and sprite
        DS_health_txt.runAction(healthTextMovementAction, withKey: "move")
        DS_health_bar.runAction(healthTextMovementAction, withKey:"move")
       // adjustBarAnchorPoint()
        sprite.runAction(walkSequence, withKey: "move")
    }
    
    func clearMove(){
        self.sprite.removeActionForKey("move")
        self.sprite.removeActionForKey("moveAnim")
        self.DS_health_txt.removeActionForKey("move")
        self.DS_health_bar.removeActionForKey("move")
    }
    
    func attack(target: Unit, complete:(()->Void)!){
        clearAttack()
        DS_attackTarget = target
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
        let animationGapDistance: CGFloat = 80.0 //Default value is overwritten in init
        let refreshRate: CGFloat = 0.25
        
        if target.alive == true{         //ENSURE ATTACK IS STILL VALID
            
            /* Determine move position */
            var movePos: CGPoint
            if(self.sprite.position.x < target.sprite.position.x){
                movePos = CGPoint(x: target.sprite.frame.minX-animationGapDistance, y: target.sprite.frame.midY)
            }else{
                movePos = CGPoint(x: target.sprite.frame.maxX+animationGapDistance,y : target.sprite.frame.midY)
            }
            
            
            if Game.global.getDistance(self.sprite.position, p2: movePos) > tolerence {
                //Move a short distance towards the movePos. Dont move more than the distance to the move pos (hence the min function for distance). And call attack cycle again once the move is complete.
                let adjustedMove: CGPoint = Game.global.getPointOffsetTowardPoint(self.sprite.position, p2:movePos, distance: min(self.speed.get()*refreshRate, Game.global.getDistance(self.sprite.position, p2:movePos)))
                self.move(adjustedMove, complete:{
                    self.attackCycle(target, complete: complete)
                })
            } else {
                //Correct Facing
                if self.sprite.position.x < target.sprite.position.x {
                    self.faceRight()
                } else {
                    self.faceLeft()
                }
                //Clear movement. (should not be executing a move action, just a walk animation action)
                clearMove()
                //Setup action. Delay by attack speed then call attack again.
                let delay = SKAction.waitForDuration(NSTimeInterval(attackSpeed.get()))
                let completeBlock = SKAction.runBlock({
                    self.attackCycle(target, complete: complete)
                })
                let attackSequence = SKAction.sequence([delay, completeBlock])
                //Run the attack sequence and the attack animation
                self.sprite.runAction(attackSequence, withKey: "attack")
                self.sprite.runAction(self.DS_attackAnim!, withKey: "attackAnim")
                //Apply the damage to the enemy. NOTE: Might be more realistic to do this half way though the attack animation.
                weaponHandle(target)
                if self.type == "Warrior"
                {
                    let soundAction = SKAction.playSoundFileNamed("swing3.wav", waitForCompletion: true)
                    self.sprite.runAction(soundAction)
                }
                else if self.type == "Mage" || self.type == "EnemyMage"
                {
                    let soundAction = SKAction.playSoundFileNamed("magic1.wav", waitForCompletion: true)
                    self.sprite.runAction(soundAction)
                }
                else
                {
                    let soundAction = SKAction.playSoundFileNamed("swing2.wav", waitForCompletion: true)
                    self.sprite.runAction(soundAction)
                }
         
            }
        }
        else {
            //target is invalid. call the complete block.
            self.sprite.runAction(SKAction.runBlock(complete))
        }
    }
    
    func clearAttack(){
        DS_attackTarget = nil
        clearMove()
        self.sprite.removeActionForKey("attack")
    }
    
    func weaponHandle(target: Unit){
        dealDamage(self.attackDamage.get(), target: target)
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
        
        //self.currentOrder.update()
    
    
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
        self.clearAttack()
        self.clearMove()
        sendOrder(Idle(receiverIn: self))
        self.sprite.removeActionForKey("stand")
        //SETUP DEATH SEQUENCE! Play Death. Wait. Then remove. REMOVING LOCALLY IS DANGEROUS
        let waitAction: SKAction = SKAction.waitForDuration(NSTimeInterval(0.0))
        let removeBlockAction:SKAction = SKAction.runBlock({
            Game.global.removeUnit(self.ID)
        })
        let soundAction = SKAction.playSoundFileNamed("mnstr12.wav", waitForCompletion: true)
        self.sprite.runAction(soundAction)
        let deathThenRemove: SKAction = SKAction.sequence([DS_deathAnim!, waitAction, removeBlockAction])
        self.sprite.runAction(deathThenRemove)
    }
    
    /*
     * Actually removes the unit from memory. Should not be called until a negitive update unit is called
     */
    func kill(){
        
    }
    
    func adjustBarAnchorPoint()
    {
        let spritePos:CGPoint = self.sprite.position
        let newAnchorPoint:CGPoint = CGPoint(x: spritePos.x, y: spritePos.y + health_txt_y_dspl)
        self.DS_health_bar.anchorPoint = newAnchorPoint
    }
    
    
    
}
