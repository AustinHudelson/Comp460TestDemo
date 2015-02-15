//
//  Unit.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
class Unit: SerializableJSON
{
    var name: String
    var health: Int
    var speed: CGFloat
    var sprite: SKSpriteNode
    var currentOrder: Order = NoneOrder()
    var walkAnim: SKAction
    var attackAnim: SKAction
    var standAnim: SKAction
    
    var health_txt: SKLabelNode
    var health_txt_y_dspl: CGFloat = 40 // The y displacement of health text relative to this unit's sprite
    
    init(name: String, health: Int, speed: CGFloat) {
        self.name = name
        self.health = health
        self.speed = speed
        /* Configure our health text */
        self.health_txt = SKLabelNode(text: self.health.description)
        self.health_txt.fontColor = UIColor.redColor()
        self.health_txt.fontSize = 40
        
        
        //
        //Define Animations here
        //
        
        let walkAtlas = SKTextureAtlas(named: "Walk")
        let attackAtlas = SKTextureAtlas(named: "Attack")
        let unitName = "Character1BaseColorization"
        let walkAnimName = "-Walk2"
        let attackAnimName = "-Attack"
        let standAnimName = "-Walk2"
//        if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName]) {
//            NSLog(@"File exists in BUNDLE");
//        } else {
//            NSLog(@"File not found");
//        }
        
        var walkTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(unitName+walkAnimName+"0"),
            walkAtlas.textureNamed(unitName+walkAnimName+"1"),
            walkAtlas.textureNamed(unitName+walkAnimName+"2"),
            walkAtlas.textureNamed(unitName+walkAnimName+"3"),
            walkAtlas.textureNamed(unitName+walkAnimName+"4"),
            walkAtlas.textureNamed(unitName+walkAnimName+"5"),
            walkAtlas.textureNamed(unitName+walkAnimName+"6"),
            walkAtlas.textureNamed(unitName+walkAnimName+"7"),
            walkAtlas.textureNamed(unitName+walkAnimName+"8"),
            walkAtlas.textureNamed(unitName+walkAnimName+"9"),
            walkAtlas.textureNamed(unitName+walkAnimName+"10"),
            walkAtlas.textureNamed(unitName+walkAnimName+"11"),
            walkAtlas.textureNamed(unitName+walkAnimName+"12"),
            walkAtlas.textureNamed(unitName+walkAnimName+"13"),
            walkAtlas.textureNamed(unitName+walkAnimName+"14"),
            walkAtlas.textureNamed(unitName+walkAnimName+"15"),
            walkAtlas.textureNamed(unitName+walkAnimName+"16"),
            walkAtlas.textureNamed(unitName+walkAnimName+"17"),
            walkAtlas.textureNamed(unitName+walkAnimName+"18"),
            walkAtlas.textureNamed(unitName+walkAnimName+"19"),
            walkAtlas.textureNamed(unitName+walkAnimName+"20")
        ], timePerFrame: 0.05)
        
        var attackTextures = SKAction.animateWithTextures([
            attackAtlas.textureNamed(unitName+attackAnimName+"0"),
            attackAtlas.textureNamed(unitName+attackAnimName+"1"),
            attackAtlas.textureNamed(unitName+attackAnimName+"2"),
            attackAtlas.textureNamed(unitName+attackAnimName+"3"),
            attackAtlas.textureNamed(unitName+attackAnimName+"4"),
            attackAtlas.textureNamed(unitName+attackAnimName+"5"),
            attackAtlas.textureNamed(unitName+attackAnimName+"6"),
            attackAtlas.textureNamed(unitName+attackAnimName+"7"),
            attackAtlas.textureNamed(unitName+attackAnimName+"8"),
            attackAtlas.textureNamed(unitName+attackAnimName+"9"),
            attackAtlas.textureNamed(unitName+attackAnimName+"10"),
            attackAtlas.textureNamed(unitName+attackAnimName+"11"),
            attackAtlas.textureNamed(unitName+attackAnimName+"12"),
        ], timePerFrame: 0.05)
        
        var standTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(unitName+standAnimName+"0")
        ], timePerFrame: 0.1)
        
        self.walkAnim = SKAction.repeatActionForever(walkTextures)
        self.standAnim = SKAction.repeatActionForever(standTextures)
        self.attackAnim = SKAction.repeatAction(attackTextures, count: 1)
        
        //self.sprite = SKSpriteNode(imageNamed:"Character1BaseColorization-Stand")
        //var mir = SKAction.scaleXTo(-0.25, duration: 0.0)
        
        //self.sprite.runAction(self.walkAnim)
        //self.sprite.runAction(mir)
        sprite = SKSpriteNode(imageNamed: "Mage")
        self.sprite.runAction(self.standAnim)
        
    }
    
    /*
        Used to add a unit to the game scene at position 'pos', with sprite.xScale = 'scaleX' & sprite.yScale = 'scaleY'.
        Also displays a health text on top of this unit
    */
    func addUnitToGameScene(gameScene: GameScene, pos: CGPoint, scaleX: CGFloat, scaleY: CGFloat)
    {
        self.sprite.xScale = scaleX
        self.sprite.yScale = scaleY
        self.sprite.position = pos
        gameScene.addChild(self.sprite)
        
        /* Add health text */
        var health_txt_pos: CGPoint = pos
        health_txt_pos.y += self.health_txt_y_dspl
        self.health_txt.position = health_txt_pos
        gameScene.addChild(self.health_txt)
        
    }
    /* !!!!!!NEED TO CHANGE THESE TWO IN FUTURE!!!!!! */
    func sendOrder(order: Order){
        currentOrder.remove()
        currentOrder = order
        currentOrder.apply()
    }
    /* Apply Move */
    func apply(order: Order)
    {
        println("APPLY")
        if order is Move
        {
            println("APPLYMOVE")
            let moveLoc = (order as Move).moveToLoc
            move(moveLoc, {})
           
        }
    }
    /* Apply Attack */
    func apply(order: Order, target: Unit)
    {
        if order is Attack
        {
            move(target.sprite.position, {})
            //sprite.runAction(<#action: SKAction!#>, completion: <#(() -> Void)!##() -> Void#>)
            target.takeDamage(1)
            target.health_txt.text = target.health.description
        }
    }
    
    func takeDamage(damage:Int)
    {
        health-=damage
        println("\(name), \(health)")
    }
    
    func move(destination:CGPoint, complete:(()->Void)!)
    {
        println("MOVING")
        let charPos = sprite.position
        println(charPos)
        let xdif = destination.x-charPos.x
        let ydif = destination.y-charPos.y
        
        let distance = sqrt((xdif*xdif)+(ydif*ydif))
        let duration = distance/speed
        let movementAction = SKAction.moveTo(destination, duration:NSTimeInterval(duration))
        let walkAnimationAction = self.walkAnim
        //Create action for "Walk to point then do "complete""
        let walkSequence = SKAction.sequence([movementAction, SKAction.runBlock(complete)])
        /* Move the health text */
        var health_txt_des = destination
        
        health_txt_des.y += health_txt_y_dspl
        let moveHealthTxtAction = SKAction.moveTo(health_txt_des, duration: NSTimeInterval(duration))
        health_txt.runAction(moveHealthTxtAction, withKey: "move")
        sprite.runAction(walkSequence, withKey: "move")
        sprite.runAction(self.walkAnim, withKey: "moveAnim")
    }
    
    func clearMove(){
        self.sprite.removeActionForKey("move")
        self.sprite.removeActionForKey("moveAnim")
        self.health_txt.removeActionForKey("move")
    }
    
}
