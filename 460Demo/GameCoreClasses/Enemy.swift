//
//  Warrior.swift
//  460Demo
//
//  Created by Olyver on 1/31/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation

@objc(Enemy)
class Enemy: Unit, PType
{
    var AnimationName = "Character1BaseColorization"
    
    required init(receivedData: Dictionary<String, AnyObject>){
        //Special case for sprite
        super.init(receivedData: receivedData)
        
        restoreProperties(Warrior.self, receivedData: receivedData)
        
        //Initializes all the DS_ animations
        initializeAnimations()
        /* Sprite setup */
        sprite = SKSpriteNode(imageNamed: "Mage")
        let spawnLoc = CGPoint(x: (receivedData["posX"] as CGFloat), y: (receivedData["posY"] as CGFloat))
        sprite.position = spawnLoc
        self.sprite.runAction(self.DS_standAnim)
    }
    
    override init(ID:String, spawnLocation: CGPoint)
    {
        super.init(ID:ID, spawnLocation: spawnLocation)
        //INITILIZE THE UNITS STATS HERE!!!
        self.type = "Enemy"
        self.health = 30
        self.maxhealth = 30
        self.healthregen = 1
        self.speed = 30.0
        self.sprite.xScale = 1.0
        self.sprite.yScale = 1.0
        
        //Initializes all the DS_ animations
        initializeAnimations()
        /* Sprite setup */
        sprite = SKSpriteNode(imageNamed: "Mage")
        sprite.position = spawnLocation
        self.sprite.runAction(self.DS_standAnim)
    }
    
    /*
    * Initializes the animations for this class
    */
    func initializeAnimations(){
        //
        //Define Animations here
        //
        
        let walkAtlas = SKTextureAtlas(named: "Walk")
        let attackAtlas = SKTextureAtlas(named: "Attack")
        let walkAnimName = "-Walk2"
        let attackAnimName = "-Attack"
        let standAnimName = "-Walk2"
        
        var walkTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(AnimationName+walkAnimName+"0"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"1"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"2"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"3"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"4"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"5"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"6"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"7"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"8"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"9"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"10"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"11"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"12"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"13"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"14"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"15"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"16"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"17"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"18"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"19"),
            walkAtlas.textureNamed(AnimationName+walkAnimName+"20")
            ], timePerFrame: 0.05)
        
        var attackTextures = SKAction.animateWithTextures([
            attackAtlas.textureNamed(AnimationName+attackAnimName+"0"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"1"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"2"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"3"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"4"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"5"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"6"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"7"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"8"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"9"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"10"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"11"),
            attackAtlas.textureNamed(AnimationName+attackAnimName+"12"),
            ], timePerFrame: 0.05)
        
        var standTextures = SKAction.animateWithTextures([
            walkAtlas.textureNamed(AnimationName+standAnimName+"0")
            ], timePerFrame: 0.1)
        
        self.DS_walkAnim = SKAction.repeatActionForever(walkTextures)
        self.DS_standAnim = SKAction.repeatActionForever(standTextures)
        self.DS_attackAnim = SKAction.repeatAction(attackTextures, count: 1)
    }
    
    override func addUnitToGameScene(gameScene: GameScene, pos: CGPoint) {
        super.addUnitToGameScene(gameScene, pos: pos)
        self.sendOrder(RoamAttack(receiverIn: self))
        self.applyTint(SKColor.redColor(), factor: 0.75, blendDuration: NSTimeInterval(0.0))

    }
    
    
}
