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
    var DS_healthregen: Int = 0
    var speed: Attribute = Attribute(baseValue: 0.0)
    var DS_deadButAliveCounter: Int = 0
    var xSize: CGFloat = 200.0
    var ySize: CGFloat = 200.0
    var attackRange: CGFloat = 20.0
    var attackSpeed: Attribute = Attribute(baseValue: 3.0)
    var attackDamage: Attribute = Attribute(baseValue: 3.0)
    var DS_lastAttackTime: NSDate = Timer.getCurrentTime()
    /* 
    if isHealer is true, then this unit will only be able to target allies 
    with attack commands (only applies to players)
    */
    var isHealer: Bool = false
    var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "") // init a sprite with no texture, subclass should override this variable
    var redColor: Attribute = Attribute(baseValue: 1.0)
    var blueColor: Attribute = Attribute(baseValue: 1.0)
    var greenColor: Attribute = Attribute(baseValue: 1.0)
    var currentOrder: Order = NoneOrder()
    var alive: Bool = true
    var DS_moveDestination: CGPoint? // used in synching positions
    var DS_completeBlock: (()->Void)!?//used in synching positions
    var DS_walkAnim: SKAction?
    var DS_attackAnim: SKAction?
    var DS_standAnim: SKAction?
    var DS_deathAnim: SKAction?
    var DS_stumbleAnim: SKAction?
    var DS_abilityAnim: SKAction?
    var isEnemy: Bool = true
    var DS_attackTarget: Unit?                  //used in synching positions and other things
    var DS_attackCompleteBlock: (()->Void)!?    //used in synching positions
    var DS_isCommandable: Bool = true   /*Private*/
    var DS_queuedOrder: Order?
    var DS_isFacingLeft: Bool = false
    
    var DS_health_txt: SKLabelNode = SKLabelNode(text: "")
    var DS_health_bar: SKSpriteNode = SKSpriteNode(imageNamed: "InnerHealthBar")
    var DS_health_bar_outline: SKSpriteNode = SKSpriteNode(imageNamed: "OutterHealthBar")
    let DS_health_bar_outline_padding: CGFloat = 2.0
    var DS_health_bar_y: CGFloat = 32.0
    var DS_health_bar_max_x: CGFloat?
    var DS_health_txt_y_dspl: CGFloat = 100 // The y displacement of health text relative to this unit's sprite
    var DS_health_bar_x_dspl: CGFloat = -35
    var DS_zSpriteOffset: CGFloat = 2
    var DS_zHealthOffset: CGFloat = 3
    
    var DS_deadOrder: Order?
    
    var DS_enemySyncOrderCounter: Int = 0
    
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init()
        
        restoreProperties(Unit.self, receivedData: receivedData)
        
        // ===TESTING
        var barSize: CGSize = CGSize(width: CGFloat(100), height: CGFloat(25))
        self.DS_health_bar.size = barSize
        
        self.sprite.anchorPoint = CGPoint(x:0, y:0)
        //self.DS_health_bar.anchorPoint = CGPoint(x:0, y:0)
        
        self.sprite.zPosition = Game.global.spriteMinZ + Game.global.scene!.frame.maxY - self.sprite.position.y
        self.DS_health_bar.zPosition = self.sprite.zPosition + 3
        
       
    }
    
    init(ID: String, spawnLocation: CGPoint) {
        super.init()
        self.ID = ID
        self.currentOrder = NoneOrder()
        
        
        // ===TESTING
        self.sprite.anchorPoint = CGPoint(x:0, y:0)
        //self.DS_health_bar.anchorPoint = CGPoint(x:0, y:0)
        
        self.sprite.zPosition = Game.global.spriteMinZ + Game.global.scene!.frame.maxY - self.sprite.position.y
        self.DS_health_bar.zPosition = self.sprite.zPosition + 3
    }
    
    /* Helper function that loads an animation into SKAction */
    func getAnimationAction(AnimationName: String, classPrefix: String, animGroupName: String, timePerFrame: NSTimeInterval) -> SKAction {
        
        var Atlas: SKTextureAtlas = SKTextureAtlas(named: classPrefix+animGroupName)
        var animTextures: Array<SKTexture> = []
        
        /*
            - String formatting in Swift:
            https://thatthinginswift.com/string-formatting/
            https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
            - %@ means input.description (eg. %@, animPrefix will result in %@ being replaced by animPrefix.description)
            - %d means an integer
        */
        for index in 0..<Atlas.textureNames.count {
            let textureName = String(format: "%@%@%d", AnimationName, animGroupName, index)
            animTextures.append(Atlas.textureNamed(textureName))
        }
        
        return SKAction.animateWithTextures(animTextures, timePerFrame: timePerFrame)
    }
    
    
    /*
        Used to add a unit to the game scene at position 'pos', with sprite.xScale = 'scaleX' & sprite.yScale = 'scaleY'.
        Also displays a health text on top of this unit
    */
    func addUnitToGameScene(gameScene: GameScene, pos: CGPoint)
    {
        self.sprite.position = pos
        
        //Setup health bars here.
        self.sprite.addChild(self.DS_health_bar_outline)
        self.sprite.addChild(self.DS_health_bar)
        self.DS_health_bar.position = CGPoint(x: 0, y: self.sprite.size.height*0.5)
        self.DS_health_bar_outline.position = CGPoint(x: 0, y: self.sprite.size.height*0.5)
        //Setup healthbar size based on size of sprite.
        self.DS_health_bar_outline.size = CGSize(width: self.sprite.size.width*0.7, height: self.DS_health_bar_y)
        //Setup inside of the healthbar based on the size of the outline.
        self.DS_health_bar.size = CGSize(width: self.DS_health_bar_outline.size.width-(2.0 * DS_health_bar_outline_padding), height: self.DS_health_bar_y-(2.0*DS_health_bar_outline_padding))
        self.DS_health_bar.zPosition = 99999.0
        self.DS_health_bar.zPosition = 88888.0
        self.DS_health_bar_max_x = self.DS_health_bar.size.width
        
        //Setup health bar color
        var color: UIColor = UIColor.whiteColor()
        if (self.isEnemy == true) {
            color = UIColor.redColor()
        } else {
            let player = Game.global.getMyPlayer()
            if (player != nil && player! == self){
                color = UIColor.greenColor()
            } else {
                color = UIColor.blueColor()
            }
        }
        
        let changeColorAction = SKAction.colorizeWithColor(color, colorBlendFactor: 1.0, duration: NSTimeInterval(0.0))
        self.DS_health_bar.runAction(changeColorAction)
        
        gameScene.addChild(self.sprite)
        self.faceRight()
        
        /* Add health text */
        //var health_txt_pos: CGPoint = pos
        //health_txt_pos.y += self.health_txt_y_dspl
        //self.DS_health_txt.position = health_txt_pos
        
        //var health_bar_pos: CGPoint = pos
        //health_bar_pos.y += self.health_txt_y_dspl
        //health_bar_pos.x = pos.x + health_bar_x_dspl //can't get it to work other than hard coding
        //self.DS_health_bar.position = health_bar_pos
        //gameScene.addChild(self.DS_health_txt)
        //gameScene.addChild(self.DS_health_bar)
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
            //If this unit is uncommandable queue the wd instead
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
        
        self.updateHealthBar()
    }
    
    func dealHealing(heal: CGFloat, target: Unit) {
        target.takeHealing(heal)
    }
    
    func takeHealing(heal: CGFloat){
        health += heal
        
        if health > maxhealth.get()
        {
            health=maxhealth.get()
        }
        
        self.updateHealthBar()
    }
    
    func faceLeft(){
        self.DS_isFacingLeft = true
        self.sprite.runAction(SKAction.scaleXTo(-1.0, duration: 0.0))
        self.DS_health_bar.position.x = fabs(self.DS_health_bar.position.x)
    }
    
    func faceRight(){
        self.DS_isFacingLeft = false
        self.sprite.runAction(SKAction.scaleXTo(1.0, duration: 0.0))
        self.DS_health_bar.position.x = -fabs(self.DS_health_bar.position.x)
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
        DS_moveDestination = destination
        DS_completeBlock = complete
        moveCycle(destination, complete: complete)
    }
    
    
    /*
     * Recursive function that moves the unit a short distance towards destination
     * and then calls itself again. calls complete upon reaching the destination
     */
    func moveCycle(destination: CGPoint, complete:(()->Void)!){
        let refreshRate: CGFloat = 0.75
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
        //var healthTextAdjustedMove = adjustedMove
        //healthTextAdjustedMove.y += health_txt_y_dspl
        //healthTextAdjustedMove.x += health_bar_x_dspl
        //let healthTextMovementAction = SKAction.moveTo(healthTextAdjustedMove, duration:NSTimeInterval(duration))
        
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
        //DS_health_txt.runAction(healthTextMovementAction, withKey: "move")
        //DS_health_bar.runAction(healthTextMovementAction, withKey:"move")
        // adjustBarAnchorPoint()
        sprite.runAction(walkSequence, withKey: "move")
        self.sprite.zPosition = setZPosition(self.sprite.position.y) + self.DS_zSpriteOffset
        self.DS_health_bar.zPosition = setZPosition(self.DS_health_bar.position.y) + self.DS_zHealthOffset
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
        DS_attackCompleteBlock = complete
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
        let moveTolerence: CGFloat = 5.0
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
                // IF this adjusted move should put you within Attack Range, then
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
                let currentTime = Timer.getCurrentTime()
                let timeSinceLastAttack: NSTimeInterval = currentTime.timeIntervalSinceDate(DS_lastAttackTime)
                if (timeSinceLastAttack < NSTimeInterval(attackSpeed.get()-0.01)){ //Give a bit of leeway for floating point madness
                    println("Delaying attack cycle due to recent attack")           //Debug, should only print if the unit gets an additional attack command.
                    println(timeSinceLastAttack)
                    let delayAttack = SKAction.waitForDuration(NSTimeInterval(attackSpeed.get()+0.05)-timeSinceLastAttack) //Give attack some leeway
                    let delayComplete = SKAction.runBlock({
                        self.attackCycle(target, complete: complete)
                    })
                    self.sprite.runAction(SKAction.sequence([delayAttack, delayComplete]), withKey: "attack")
                    return
                }
                DS_lastAttackTime = currentTime
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
    * Call to synchronize this unit with the host. Will correct current life and
    * position if it has deviated too far from the host.
    *
    * Will also replace the current order this Unit is an enemy & tID is different.
    */
    func synchronize(receivedLife: CGFloat, receivedPosition: CGPoint, tID: String){
        //Sync Health
        if (self.alive == true){
            //is alive
            if (receivedLife > 0.0){
                //Should be alive
                self.health = receivedLife
                updateHealthBar()
            } else {
                //Should be dead
                self.kill()
                return
            }
        } else {
            //is dead
            if (receivedLife > 0.0){
                //Should be alive
                if DS_deadButAliveCounter == 0
                {
                    DS_deadButAliveCounter += 1
                }
                else
                {
                    self.health = receivedLife
                    self.revive(receivedPosition)
                    updateHealthBar()
                    DS_deadButAliveCounter = 0
                }
                
            } else {
                //Should be dead
                self.kill()
                return
            }
        }
        
        // If this unit is an enemy, check to see if its order needs to be updated
        if self.isEnemy {
            if !(self.currentOrder is Idle) && (tID != "") && (self.currentOrder.tID != tID) {
                var newTarget: Unit? = Game.global.getUnit(tID)
                
                // This counter is for waiting until 2 sync msgs come, and you only update the order after 2 msgs, b/c else you get some problem similar to death
                if DS_enemySyncOrderCounter == 0
                {
                    DS_enemySyncOrderCounter += 1
                }
                else {
                    if self.type == "EnemyPriest" {
                        if newTarget != nil {
                            (self.currentOrder as RoamHeal).redirect(newTarget!)
                        }
                    }
                    else {
                        // It's an Enemy with Roam attack
                        if newTarget != nil {
                            (self.currentOrder as RoamAttack).redirect(newTarget!)
                        }
                    }
                    
                    DS_enemySyncOrderCounter = 0
                }
            }
        }
        
        //Sync Position
        
        if Game.global.getDistance(self.sprite.position, p2: receivedPosition) > self.speed.get() * 0.6
        {
            if self.sprite.actionForKey("move") != nil
            {
                self.clearMove()
                self.sprite.position = receivedPosition
                if self.DS_attackTarget != nil {
                    let currentTarget = self.DS_attackTarget!
                    self.clearAttack()
                    self.attack(currentTarget, complete: DS_attackCompleteBlock)
                    println("replaced attack")
                } else {
                    self.move(DS_moveDestination!, complete: self.DS_completeBlock!)
                    println("replaced move")
                }
            }
            else
            {
                self.sprite.position = receivedPosition
                println("Not moving")
            }
            println("changing position")
        }
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
        self.DS_health_bar.removeFromParent()
        self.DS_health_bar_outline.removeFromParent()
        //applyTint(SKColor.blackColor(), factor: 1.0, blendDuration: 1.0)
        self.clearAttack()
        self.clearMove()
        //Store the dead order
        self.DS_deadOrder = self.currentOrder
        
        sendOrder(Idle(receiverIn: self))
        self.sprite.removeActionForKey("stand")
        //SETUP DEATH SEQUENCE! Play Death. Wait. Then remove. REMOVING LOCALLY IS DANGEROUS
        let waitFadeAction: SKAction = SKAction.waitForDuration(NSTimeInterval(4.0))
        let fadeOutAction:SKAction = SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(3.0))
        let waitSceneRemove: SKAction = SKAction.waitForDuration(NSTimeInterval(4.0))
        let removeFromSceneAction: SKAction = SKAction.runBlock({
            self.sprite.removeAllActions()
            self.sprite.removeAllChildren()
            self.sprite.removeFromParent()
        })
        let soundAction = SKAction.playSoundFileNamed("mnstr12.wav", waitForCompletion: true)
        self.sprite.runAction(soundAction)
        let deathThenRemove: SKAction = SKAction.sequence([DS_deathAnim!, waitFadeAction, fadeOutAction, waitSceneRemove, removeFromSceneAction])
        self.sprite.runAction(deathThenRemove, withKey: "death")
    }
    
    /*
     * Actually removes the unit from memory. Should not be called until a negitive update unit is called
     */
    func kill(){
        Game.global.removeUnit(self.ID)
        if alive == true {
            death()
        }
    }
    
    /*
     * Used to restore a unit to existance after it has been locally killed but then a sync
     * message is received notifying that it should still be alive.
     */
    func revive(position: CGPoint){
        self.sprite.removeActionForKey("death")
        self.sprite.hidden = false
        self.alive = true
        self.sprite.runAction(SKAction.fadeAlphaTo(1.0, duration:NSTimeInterval(0.0)))
        self.sprite.addChild(DS_health_bar)
        self.sprite.addChild(DS_health_bar_outline)
        self.sendOrder(DS_deadOrder!)
        DS_deadOrder = nil
    }
    
//    func adjustBarAnchorPoint()
//    {
//        let spritePos:CGPoint = self.sprite.position
//        let newAnchorPoint:CGPoint = CGPoint(x: spritePos.x, y: spritePos.y + health_txt_y_dspl)
//        self.DS_health_bar.anchorPoint = newAnchorPoint
//    }
    
    func updateHealthBar()
    {
        if (self.alive == false){
            return
        }
        let newX: CGFloat = DS_health_bar_max_x! * (self.health/self.maxhealth.get())
        //When bar is oriented around center, offset by half of the differance in the size of the bar
        let newXOffset: CGFloat = 0.5 * (DS_health_bar_max_x! - newX)
        DS_health_bar.size.width = newX
        if (self.DS_isFacingLeft == true){
            DS_health_bar.position.x = fabs(newXOffset)
        } else {
            DS_health_bar.position.x = -fabs(newXOffset)
        }
        
    }
    
    
    //put in the y position of the sprite to get the zposition you should have
    func setZPosition (y:CGFloat)-> CGFloat
    {
        return Game.global.scene!.frame.maxY - self.sprite.position.y
    }
    
    
}
