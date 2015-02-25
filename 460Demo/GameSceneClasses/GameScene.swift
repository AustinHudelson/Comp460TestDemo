//
//  GameScene.swift
//  460Demo
//
//  Created by Austin Hudelson on 1/22/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
import Foundation



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    /* WARNING: CURRENTLY TWO COPPIES OF unit_list EXIST. THE ONE THAT IS LOCAL TO GAME SCENE AND THE ONE
     * ACCESSED THROUGH GameScene.global.unit_list[]. THIS NEEDS TO BE FIXED AT SOME POINT EXTREMELY SOON
     */
    var unit_list: Dictionary<String, Unit> = [:] // Our list of units in the scene
    var playerIsTouched = false
    
    class var global:GameScene{
        struct Static{
            static var instance:GameScene?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            Static.instance = GameScene()
        }
        return Static.instance!
    }
    
    /*
        Update the game state according to dictionary received over the network
    */
    func updateGameState(recvDict: Dictionary<String, Array<Dictionary<String, AnyObject>>>) {
        for (key: String, arrayOfObjects: Array<Dictionary<String, AnyObject>>) in recvDict {
            if key == "Units" {
                for unit in arrayOfObjects {
                    // Make a new unit by calling its corresponding constructor
                    if unit_list[unit["ID"] as String] == nil {
                        var anyobjecttype: AnyObject.Type = NSClassFromString(unit["type"] as NSString)
                        var nsobjecttype: Unit.Type = anyobjecttype as Unit.Type
                        var newUnit: Unit = nsobjecttype(receivedData: unit)
                        
                        unit_list[newUnit.ID] = newUnit
                        GameScene.global.unit_list[newUnit.ID] = newUnit
                        let spawnLoc = CGPoint(x: (unit["posX"] as CGFloat), y: (unit["posY"] as CGFloat))
                        
                        newUnit.currentOrder = Idle(receiverIn: newUnit) //TEMPORARY WORKAROUND FOR ORDERS THAT DO NOT DESERIALIZE PROPERLY
                        
                        newUnit.addUnitToGameScene(self, pos: spawnLoc, scaleX: 1.0, scaleY: 1.0)
                        
                        sendUnit(unit_list[AppWarpHelper.sharedInstance.playerName]!) // send myself to everyone who hasn't got me
                    }
                }
            }
            if key == "Orders" {
                for order in arrayOfObjects {
                    // Make an Order object out of what is received
                    var anyobjecttype: AnyObject.Type = NSClassFromString(order["type"] as NSString)
                    var nsobjecttype: Order.Type = anyobjecttype as Order.Type
                    var newOrder: Order = nsobjecttype(receivedData: order, unitList: unit_list)
                    
                    (unit_list[newOrder.ID!]!).sendOrder(newOrder) //SEND THE ORDER TO ITS UNIT
                    //newOrder.valueForKey("DS_receiver")
                }
            }
        }
    }

    func startGameScene() {
        println("GAME SCENE START")
        
        // Create a warrior unit with name = player name
        var playerName = AppWarpHelper.sharedInstance.playerName
        let war_position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        let war = Warrior(ID:playerName, health: 100, speed: CGFloat(100.1), spawnLocation: war_position)
        
        sendUnit(war) //Adds and send the unit
        
        //Create a unit on the scene, should have the same ID for all players so should only create one time
        let DUMMY_ID = "1"
        let dummy_position = CGPoint(x:CGRectGetMidX(self.frame)-50, y:CGRectGetMidY(self.frame));
        let dummy = Enemy(ID: DUMMY_ID, health: 30, speed: CGFloat(20.0), spawnLocation: dummy_position)
        
        sendUnit(dummy)
    }
    
    //Does all work necessary to add a unit to the game for all connected players
    func sendUnit(newUnit: Unit){
        //unit_list[newUnit.ID] = newUnit
        //newUnit.addUnitToGameScene(self, pos: position, scaleX: 0.5, scaleY: 0.5)
        
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Units"] = []
        sendData["Units"]!.append(newUnit.toJSON())
        AppWarpHelper.sharedInstance.sendUpdate(sendData)
    }
    
    func removeUnitFromGame(unit: Unit){
        var sendData: Dictionary<String, Array<AnyObject>> = [:]
        sendData["Kill"]!.append(unit.ID)
        AppWarpHelper.sharedInstance.sendUpdate(sendData)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("Game Scene Init")
        
        
        
        AppWarpHelper.sharedInstance.gameScene = self
        
        let background = SKSpriteNode(imageNamed: "Background1")
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        background.size = CGSize(width: CGFloat(self.size.width), height: CGFloat(self.size.height));
        //background.position = CGPoint(x: 0, y: 0)
        //background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        
        // physics
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        //
        
    }
    
    /// physics
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstNode = contact.bodyA.node as SKSpriteNode
        let secondNode = contact.bodyB.node as SKSpriteNode
        
        //firstNode.removeActionForKey("move")
        //firstNode.removeActionForKey("moveAnim")
        let contactPoint = contact.contactPoint
        let contact_y = contactPoint.y
        let target_y = secondNode.position.y
        let margin = secondNode.frame.size.height/2 - 25
     
                println("Hit")
        
    }
    ////
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)

            /*
                Determine if the touch is on your own character's sprite
            */

                if unit_list[AppWarpHelper.sharedInstance.playerName]!.sprite.containsPoint(touchLocation) {
                    playerIsTouched = true
                }
        }
    }
    override func touchesEnded(touches:NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            if playerIsTouched == true {
                let touchLocation = touch.locationInNode(self)
                var unitTouched = false;
                var touchedUnitID: String = ""
                for (name, unit) in unit_list
                {
                    //Attack target conditions go here
                    if(unit.sprite.containsPoint(touchLocation) && (unit.ID != AppWarpHelper.sharedInstance.playerName))
                    {
                        unitTouched = true;
                        touchedUnitID = unit.ID
                        break
                    }
                }
                
                var sendData: Dictionary<String, Array<AnyObject>> = [:]
                if(unitTouched)
                {
                    var attack: Attack = Attack(receiverIn: unit_list[AppWarpHelper.sharedInstance.playerName]!, target: unit_list[touchedUnitID]!)
                    sendData["Orders"] = []
                    sendData["Orders"]!.append(attack.toJSON())
                    
                }
                else
                {
                    var move_loc: Move = Move(receiverIn: unit_list[AppWarpHelper.sharedInstance.playerName]!, moveToLoc: touchLocation)
                    sendData["Orders"] = []
                    sendData["Orders"]!.append(move_loc.toJSON())
                    
//                    for unit in unit_list
//                    {
//                        if unit.name == AppWarpHelper.sharedInstance.playerName
//                        {
//                            unit.apply(move_loc)
//                            break
//                        }
//                        
//                    }
                    
//
//                    
//                    
//                    ////Convert the touched location to a string for projectile position
//                    //var destStr:String = NSStringFromCGPoint(location)
//                    //dataDict.setObject(destStr, forKey: "projectileDest")
//                    
//                    //Convert the player position to a string
//                //var playerPosition:String = NSStringFromCGPoint(location)
//                    //Add the string to the dictionary
//                //dataDict.setObject(playerPosition, forKey: "playerPosition")
//                    //dataDict.setObject(NSValue(CGPoint: player!.position), forKey: "playerPosition")
//                    
//                    var move = Move(position1: location)
//                    //println(move);
//                    dataDict.setObject(move.description, forKey: "move")
//                    
//                    
//                    //Notify Room of updated data
//                    
                }
                AppWarpHelper.sharedInstance.sendUpdate(sendData)
                playerIsTouched = false
//                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
//                    objectTouched = false
            }
           
            
        }
    }
    
    var TEMPREMOVECOUNTER: Int = 0
    
    override func update(currentTime: CFTimeInterval) {
        /*
            Go through each unit in the unit_list and do a runAction on their corresponding Order
        */
        
        //SIMULATE UPDATE LOOP. THIS IS LIKE THE WORST WAY TO DO THIS EVER!
        TEMPREMOVECOUNTER += 1
        if (TEMPREMOVECOUNTER == 15){
            TEMPREMOVECOUNTER = 0
            for (id, unit) in unit_list {
                unit.update()
            }
        }
        
    }
    
    
    /*
     * GLOBAL HELPER FUNCTIONS FOR GETTING UNITS! GAME SCENE MIGHT
     * NOT BE THE BEST PLACE TO STORE THESE. MAYBE A UTIL FILE?
     * CONSIDER CHANGING THIS STRUCTURE LATER
     */
    
    /*
     *Function to get distance between 2 CGPoints
     */
    func getDistance(p1: CGPoint, p2: CGPoint) -> CGFloat{
        let xDist = (p2.x - p1.x);
        let yDist = (p2.y - p1.y);
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    /*
     * Function to QUICKLY get a RELATIVE distance.
     * Does not run the sqrt function, instead simply returns its square.
     * When comparing distances it is not required to know the actual distance.
     */
    func getRelativeDistance(p1: CGPoint, p2: CGPoint) -> CGFloat{
        let xDist = (p2.x - p1.x);
        let yDist = (p2.y - p1.y);
        return ((xDist * xDist) + (yDist * yDist));
    }
    
    /*
     * Returns the closest PLAYER to the given point
     */
    func getClosestPlayer(p1: CGPoint) -> Unit {
        var nearby: Unit?
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in unit_list {
            if unit is Enemy{   //WARNING: THIS IS A TERRIBLE WAY TO CHECK ALLIANCE... MUST UPDATE LATER
                continue
            }
            var p2 = unit.sprite.position
            var dist = getRelativeDistance(p1, p2:p2)
            if dist < near{
                nearby = unit
                near = dist
            }
        }
        
        if nearby == nil {
            fatalError("Unable to find closest player to point. Empty player list?")
        }
        
        return nearby!
    }
}
