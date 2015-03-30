//
//  Game.swift
//  460Demo
//
//  Created by Austin Hudelson on 2/27/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation
import SpriteKit

/*
* Global class that handles units and game interaction
*/
class Game {
    
    //var unitMap: Dictionary<String, Unit> = [:]
    var playerMap: Dictionary<String, Unit> = [:] // Our list of players in the scene
    var enemyMap: Dictionary<String,Unit> = [:] //our list of AI characters
    var scene: GameScene?
    var level: Level?
    var myPlayerIsDead = false
    var enemyIDCounter = 0
    
    class var global:Game{
        struct Static{
            static var instance:Game?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            Static.instance = Game()
        }
        return Static.instance!
    }
    
    /*
        This is just a helper function to get rid of all the whitespaces in a string so we can go from Strings to Class Names faster (eg. "Level One" to "LevelOne1").
        http://stackoverflow.com/questions/7628470/remove-all-whitespace-from-nsstring
        http://stackoverflow.com/questions/26963379/remove-whitespace-character-set-from-string-excluding-space-swift
    */
    func removeWhiteSpaces(inputStr: String) -> String {
        let words = inputStr.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var outputStr: String = ""
        for word in words {
            outputStr += word
        }
        return outputStr
    }
    
    /*
     * Clears all the global data in this class to the default values
     */
    func clearGlobals(){
        for (id, unit) in Game.global.playerMap{
            unit.death()
        }
        for (id, unit) in Game.global.enemyMap{
            unit.death()
        }
        playerMap = [:]
        enemyMap = [:]
        myPlayerIsDead = false
        enemyIDCounter = 0
    }
    
    
    /*
     *  Adds a Unit respresenting a player
     */
    func addPlayer(player: Unit){
        if playerMap[player.ID] == nil{
            playerMap[player.ID] = player
        } else {
            println("WARNING: ADDED UNIT WITH ALREADY EXISTING ID TO GAME")
        }
    }
    /*
     *Adds an enemy
     */
    func addEnemy(enemy: Unit)
    {
        if enemyMap[enemy.ID] == nil{
            enemyMap[enemy.ID] = enemy
        } else {
            println("WARNING: ADDED UNIT WITH ALREADY EXISTING ID TO GAME")
        }
    }
    
    func getNextEnemyID() -> String {
        enemyIDCounter++
        return (enemyIDCounter.description+"e")
    }
    
    /*
     */
    func removeUnit(ID:String){
        println("removing unit")
        if playerMap[ID] != nil
        {
            
            var player = playerMap[ID]!
            playerMap[ID] = nil
            let remove: SKAction = SKAction.removeFromParent()
            player.DS_health_txt.runAction(remove)
            player.sprite.runAction(remove)
            if ID == AppWarpHelper.sharedInstance.playerName
            {
                myPlayerIsDead = true
                localPlayerloseGame()
            }
            
            // Check if this player removal results in empty playerMap, if it is, the team loses
            if playerMap.count <= 0 {
                loseGame()
            }
        }
            
        else if enemyMap[ID] != nil
        {
            println("removing enemy")
            var enemy = enemyMap[ID]!
            enemyMap[ID] = nil
            let remove: SKAction = SKAction.removeFromParent()
            enemy.DS_health_txt.runAction(remove)
            enemy.sprite.runAction(remove)
            
            if enemyMap.count == 0 && AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host
            {
                println("Host is getting new wave")
                loadLevel()
            }
            
        }
        else
        {
            println("The ID of this unit does not exist to remove")
            
        }
     }
    
    /*
     * loads a new wave if you are the host
     */
    func loadLevel() {
        if level != nil && scene != nil {
            println("!!!!Loading \(level?.title)")
            var firstWave: Array<Unit> = level!.loadWave(scene!)
            if (firstWave.count != 0) {        //If we receive an empty wave assume that we have defeated all waves
                for enemy in firstWave{
                    scene!.sendUnitOverNetwork(enemy)
                }
            } else {
                /* Send a win game msg to everyone */
                var winMsg: Dictionary<String, Array<AnyObject>> = [:]
                winMsg["Win!"] = []
                NetworkManager.sendMsg(&winMsg)
            }
        }
        
    }
    
    /** Once all waves are complete then we show this text/screen
    */
    
    func winGame()
    {
        let winText: SKLabelNode = SKLabelNode(text: "You Win!")
        winText.fontSize = 50
        winText.fontName = "AvenirNext-Bold"
        winText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        winText.zPosition = 1000
        if let localLoseText = self.scene!.childNodeWithName("localLoseText") {
            localLoseText.removeFromParent()
        }
        self.scene!.addChild(winText)
        self.scene!.removeActionForKey("SyncAction")
    }
    
    func localPlayerloseGame()
    {
        let localLoseText: SKLabelNode = SKLabelNode(text: "You have died...")
        localLoseText.name = "localLoseText"
        localLoseText.fontName = "AvenirNext-Bold"
        localLoseText.fontSize = 50
        localLoseText.zPosition = 1000
        localLoseText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        self.scene!.addChild(localLoseText)
    }
    
    func loseGame()
    {
        let loseText: SKLabelNode = SKLabelNode(text: "You Lose!\n Game Over")
        loseText.fontName = "HelveticaNeue-Bold"
        loseText.name = "loseText"
        loseText.zPosition = 1000
        loseText.fontSize = 50
        loseText.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidX(self.scene!.frame) + 50)
        
        /*
            Check if the localLoseText is there, if it is, remove it
        */
        if let localLoseText = self.scene!.childNodeWithName("localLoseText") {
            localLoseText.removeFromParent()
        }
        
        self.scene!.addChild(loseText)
        self.scene!.removeActionForKey("SyncAction")
        
        
//        let healBlock: SKAction = SKAction.runBlock({
//            if target.alive == true {
//                target.takeDamage(-2)
//                self.healOverTime(heal-2, target:target)
//            }
//        })
//        self.DS_receiver?.sprite.runAction(SKAction.sequence([waitAction, healBlock]))
        
        
        //attempt at making segue to mainMenu
        //above is the example code i was using
        
//        let sendInterval: SKAction = SKAction.waitForDuration(NSTimeInterval(5.0))
//        
//        let segueBlock: SKAction  = SKAction.runBlock({  self.scene!.viewController?.performSegueWithIdentifier("mainMenuSegue",sender:  nil)})
//        SKAction.sequence([sendInterval, segueBlock])
    
    }
    
    /* Gets a unit given a String
    */
    func getUnit(ID: String) -> Unit?{
        if playerMap[ID] != nil
        {
            return playerMap[ID]!
        }
            
        else if enemyMap[ID] != nil//it's an enemy
        {
            return enemyMap[ID]!
        }
        else
        {
            println("The ID of this unit does not exist to get")
            return nil
        }
            
    }
   
    
    
    /* Returns your Unit
    */
    func getMyPlayer() -> Unit? {
        //TODO: Cache who my player is so you dont have to get from the map every time.
        return playerMap[AppWarpHelper.sharedInstance.playerName]
    }
    
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
     * Gets the CGPoint offset towards offset towards the target point.
     */
    func getPointOffsetTowardPoint(p1: CGPoint, p2: CGPoint, distance: CGFloat) -> CGPoint{
        let theta = atan2((p2.y-p1.y), (p2.x-p1.x))
        let x = p1.x+(distance*cos(theta))
        let y = p1.y+(distance*sin(theta))
        return CGPoint(x:x, y:y)
    }
    
    /*
    * Returns the closest PLAYER to the given point
    */
    func getClosestPlayer(p1: CGPoint) -> Unit? {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in Game.global.playerMap {
            if unit.alive == false {
                continue
            }
            var p2 = unit.sprite.position
            var dist = getRelativeDistance(p1, p2:p2)
            if dist < near{
                nearby = unit
                near = dist
            }
        }
        

        
        return nearby
    }

    /*
    * Returns the closest ENEMY to the given point
    */
    func getClosestEnemy(p1: CGPoint) -> Unit? {
        var nearby: Unit? = nil
        var near: CGFloat = CGFloat.infinity
        
        for (id, unit) in Game.global.enemyMap {
            if unit.alive == false {
                continue
            }
            var p2 = unit.sprite.position
            var dist = getRelativeDistance(p1, p2:p2)
            if dist < near{
                nearby = unit
                near = dist
            }
        }
        
//        if nearby == nil {
//            fatalError("Unable to find closest player to point. Empty player list?")
//        }
        
        return nearby
    }
    
    /*
    Get all enemies within range of a point
    */
    func getNearbyEnemies(point: CGPoint, distance: CGFloat) -> Array<Unit>{
        var nearbyUnits = Array<Unit>()
        
        for (id, unit) in Game.global.enemyMap {
            if unit.alive == false {
                continue
            }
            if (getDistance(point, p2: unit.sprite.position) > distance){
                continue
            }
            nearbyUnits.append(unit)
        }
        
        return nearbyUnits
    }
    
    /*
    Get all units within range of a point in a given Array
    */
    func getNearbyUnits(point: CGPoint, distance: CGFloat, units: Array<Unit>) -> Array<Unit>{
        var nearbyUnits = Array<Unit>()
        
        for unit in units {
            if unit.alive == false {
                continue
            }
            if (getDistance(point, p2: unit.sprite.position) > distance){
                continue
            }
            nearbyUnits.append(unit)
        }
        
        return nearbyUnits
    }
    
    // Host will call this to send host's char and every enemy's health and position every X seconds
    /*
        Our sent dicitonary will look like this:
        ["Sync":
            [
                [
                    "ID": Unit1ID,
                    "health": 100,
                    "posX": 50,
                    "posY": 60
                ],
                [
                    "ID": Unit2ID
                    ...
                ],
                ...
            ]
        ]
    */
    func sendHostSynch() {
        var outerDict: Dictionary<String, Array<AnyObject>> = [:]
        
        // ==== syncing host's character =====
        outerDict["SyncPlayer"] = []
        var playerStats: Dictionary<String, AnyObject> = [:]
        
        let playerID = AppWarpHelper.sharedInstance.playerName
        if let playerUnit = playerMap[playerID] {
            playerStats["health"] = playerUnit.health
            playerStats["posX"] = Float(playerUnit.sprite.position.x)
            playerStats["posY"] = Float(playerUnit.sprite.position.y)
            playerStats["ID"] = playerID
        }
        outerDict["SyncPlayer"]!.append(playerStats)
        
        
        // ==== syncing enemies =====
        outerDict["SyncEnemies"] = []
        var enemyStats: Dictionary<String, AnyObject> = [:]
        
        for (enemyID, enemyUnit) in enemyMap {
            enemyStats["health"] = enemyUnit.health
            enemyStats["posX"] = Float(enemyUnit.sprite.position.x)
            enemyStats["posY"] = Float(enemyUnit.sprite.position.y)
            enemyStats["ID"] = enemyID
        }
        outerDict["SyncEnemies"]!.append(enemyStats)
        
        NetworkManager.sendMsg(&outerDict)
    }
    
    // Clients will call this to send their own char's health and pos
    func sendClientSync() {
        var outerDict: Dictionary<String, Array<AnyObject>> = [:]
        
        outerDict["SyncPlayer"] = []
        var playerStats: Dictionary<String, AnyObject> = [:]
        
        let playerID = AppWarpHelper.sharedInstance.playerName
        if let playerUnit = playerMap[playerID] {
            playerStats["health"] = playerUnit.health
            playerStats["posX"] = Float(playerUnit.sprite.position.x)
            playerStats["posY"] = Float(playerUnit.sprite.position.y)
            playerStats["ID"] = playerID
        }
        outerDict["SyncPlayer"]!.append(playerStats)
            
        NetworkManager.sendMsg(&outerDict)

    }
    
    func addSyncActionToScene() {
        let sendInterval: SKAction = SKAction.waitForDuration(NSTimeInterval(0.5))
        
        var syncAction: SKAction
        // Send sync msg every X seconds if I'm host
        if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host {
            syncAction = SKAction.runBlock(Game.global.sendHostSynch)
        } else {
            syncAction = SKAction.runBlock(Game.global.sendClientSync)
        }
        
        let sendSync: SKAction = SKAction.sequence([sendInterval, syncAction])
        let repeatAction: SKAction = SKAction.repeatActionForever(sendSync)
        self.scene?.runAction(repeatAction, withKey: "SyncAction")
    }
    
    /*
        ====================================================
        These functions should be called from processRecvMsg()
    */
    /*
        This func receives the start game msg, sets the host's Game.global.level variable to whatever was selected in the lobby, and transistions the app from LobbyViewController to GameScene
    */
    func transToGameScene(startMsg: Dictionary<String, AnyObject>) {
        /*
            If i'm host:
                1. set the room property to unjoinable
                2. make a new level object & set the Game.global.level variable
        */
        if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host {
            /* Set roomProperty to unjoinable */
            AppWarpHelper.sharedInstance.updateRoomToUnjoinable()
            
            /* Go from a string to its corresponding level class */
            let levelTxt = startMsg["level"] as String
            var noSpace: String = removeWhiteSpaces(levelTxt) // get rid of the spaces in the level text
            noSpace += AppWarpHelper.sharedInstance.userName_list.count.description // append the sublevel number, which will correspond to # of players in the game
            var anyObjType: AnyObject.Type = NSClassFromString(noSpace)
            var levelType: Level.Type = anyObjType as Level.Type
            var newLevel: Level = levelType()
            
            self.level = newLevel // set Game.global.level = newLevel
        }
        
        /* Everyone perform segue to transition into game scene */
        AppWarpHelper.sharedInstance.lobby!.performSegueWithIdentifier("gameSegue", sender: nil)
    }
    
    /*
        This func adds new unit to the game based on msg received.
        (For now) This func should only be called at the start of the game b/c after game starts,
        it will crash the game when a unit dies and you call getUnit(id), which will result in nil
    */
    func updateNewUnits(arrayOfUnits: Array<AnyObject>) {
        for object in arrayOfUnits {
            let recvUnit = object as Dictionary<String, AnyObject>  // had to do this to get around Swift compile error
            let id: String = recvUnit["ID"] as String
            // Make a new unit by calling its corresponding constructor if this Unit is not in the list
            if getUnit(id) == nil // !!!WATCH OUT for this nil when a unit dies and is set to nil!!!
            {
                var anyobjecttype: AnyObject.Type = NSClassFromString(recvUnit["type"] as NSString)
                var nsobjecttype: Unit.Type = anyobjecttype as Unit.Type
                var newUnit: Unit = nsobjecttype(receivedData: recvUnit)
                if !newUnit.isEnemy
                {
                    addPlayer(newUnit)
                    //If the player is NOT YOU give it a slightly grey tint.
                    if newUnit.ID != AppWarpHelper.sharedInstance.playerName {
                        newUnit.applyTint("OtherPlayer", red: 0.8, blue: 0.8, green: 0.8)
                    } else {
                        //This is my unit
                        let myPlayerCircle = SKSpriteNode(imageNamed: "SelectionCircle_Green_Heavy")
                        let yOffset = (-0.225 * newUnit.sprite.size.height)
                        let xyRatio: CGFloat = 2.25     /*Value calcuated xSize/ySize of the circle image*/
                        let xSize = 0.5 * newUnit.sprite.size.width
                        let ySize = xSize/xyRatio
                        myPlayerCircle.size = CGSize(width: xSize, height: ySize)
                        myPlayerCircle.position = CGPoint(x: 0.0, y: yOffset)
                        myPlayerCircle.zPosition = newUnit.sprite.zPosition-5.0
                        newUnit.sprite.addChild(myPlayerCircle)
                        
                    }
                }
                else
                {
                    addEnemy(newUnit)
                }
                
                let spawnLoc = CGPoint(x: (recvUnit["posX"] as CGFloat), y: (recvUnit["posY"] as CGFloat))
                
                //newUnit.currentOrder = Idle(receiverIn: newUnit) //TEMPORARY WORKAROUND FOR ORDERS THAT DO NOT DESERIALIZE PROPERLY
                
                newUnit.addUnitToGameScene(self.scene!, pos: spawnLoc)
            }
        }
    }
    func updateUnits(arrayOfUnits: Array<AnyObject>) {
        for object in arrayOfUnits {
            let recvUnit = object as Dictionary<String, AnyObject>  // had to do this to get around Swift compile error
            
            // need to check for null on recvUnit["ID"] b/c if player is dead, the recvUnit dictionary will be empty, which means recvUnit["ID"] = nil
            if let id = recvUnit["ID"] as? String {
            
                // Update this Unit's health and position since this is probably a sync msg
                if id != AppWarpHelper.sharedInstance.playerName {
                    /*
                        Check to see if I'm a client, if I am just update this unit
                    */
                    if AppWarpHelper.sharedInstance.playerName != AppWarpHelper.sharedInstance.host {
                        if let updateUnit = getUnit(id) {
                            updateUnit.health = recvUnit["health"] as CGFloat
                            updateUnit.DS_health_txt.text = updateUnit.health.description
                            
                            let recvUnitPos: CGPoint = CGPoint(x: (recvUnit["posX"] as CGFloat), y: (recvUnit["posY"] as CGFloat))
                            var health_txt_pos = recvUnitPos
                            health_txt_pos.y += updateUnit.health_txt_y_dspl
                            
                            updateUnit.sprite.position = recvUnitPos
                            updateUnit.DS_health_txt.position = health_txt_pos
                        }
                    }
                    /*
                        If i'm the host, I don't update enemies
                    */
                    else {
                        if playerMap[id] != nil {
                            if let updateUnit = getUnit(id) {
                                updateUnit.health = recvUnit["health"] as CGFloat
                                updateUnit.DS_health_txt.text = updateUnit.health.description
                                
                                let recvUnitPos: CGPoint = CGPoint(x: (recvUnit["posX"] as CGFloat), y: (recvUnit["posY"] as CGFloat))
                                var health_txt_pos = recvUnitPos
                                health_txt_pos.y += updateUnit.health_txt_y_dspl
                                
                                updateUnit.sprite.position = recvUnitPos
                                updateUnit.DS_health_txt.position = health_txt_pos
                            }
                        }
                    }
                }
            }
        }
    }
    
    /*
        This func update all the unit's orders based on msg received
    */
    func updateUnitOrders(arrayOfOrders: Array<AnyObject>) {
        for object in arrayOfOrders {
            let order = object as Dictionary<String, AnyObject>
            // Make an Order object out of what is received
            var anyobjecttype: AnyObject.Type = NSClassFromString(order["type"] as NSString)
            var nsobjecttype: Order.Type = anyobjecttype as Order.Type
            var newOrder: Order = nsobjecttype(receivedData: order)
            if getUnit(newOrder.ID!) != nil
            {
                getUnit(newOrder.ID!)!.sendOrder(newOrder)   //SEND THE ORDER TO ITS UNIT
                //newOrder.valueForKey("DS_receiver")
            }
        }
    }
}