//
//  LobbyViewController.swift
//  460Demo
//
//  Created by Robert Ko on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit
import SpriteKit

class GameRoomViewController: UIViewController {
    var myPlayerName: String? = nil
    var myClass: String = ""
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var titleText: UITextView!
    var titleTextFont: UIFont = UIFont(name: "Papyrus", size: 40.0)!
    
    @IBOutlet weak var p1Name: UITextView!
    @IBOutlet weak var p2Name: UITextView!
    @IBOutlet weak var p3Name: UITextView!
    
    @IBOutlet weak var p1Img: UIImageView!
    @IBOutlet weak var p2Img: UIImageView!
    @IBOutlet weak var p3Img: UIImageView!
    @IBOutlet weak var levelPicker: UIPickerView!
    
    let levelDelegate: LevelSelection = LevelSelection()
    
    var classImages: Array<UIImageView> = Array<UIImageView>() // list of all our class img views
    var playerNames: Array<UITextView> = Array<UITextView>() // list of all our player name text views
    var playerNamesFont: UIFont = UIFont(name: "Helvetica Neue", size: 18.0)!
    
    @IBAction func startGameButtonAction(sender: AnyObject) {
        if myPlayerName != nil && myPlayerName == AppWarpHelper.sharedInstance.host {
            /*
                If i'm the host, send a msg to AppWarp to tell everyone to start the game.
                The game won't start until everyone receives this message.
            */
            var outerDict: Dictionary<String, Array<AnyObject>> = [:]
            outerDict["Start Game!"] = []
            
            /* Put the selected level information into the start msg */
            var startMsg: Dictionary<String, AnyObject> = [:]
            let selRow: Int = levelPicker.selectedRowInComponent(0)
            //let levelTxt: String = levelDelegate.pickerView(levelPicker, titleForRow: selRow, forComponent: 0)
            startMsg["level"] = selRow
            
            outerDict["Start Game!"]!.append(startMsg)
            
            NetworkManager.sendMsg(&outerDict)
            
            // Disable the start game button
            startGameButton.enabled = false
        } else {
            println("You need to wait for host to start the game!")
            println("Current Host \(AppWarpHelper.sharedInstance.host)")
            println("YourName \(AppWarpHelper.sharedInstance.playerName)")
        }
    }
    
    /* Pressing this button will move the screen back to character selection screen */
    @IBAction func exitButtonAction(sender: AnyObject) {
        AppWarpHelper.sharedInstance.leaveRoom()
        
        // Disable the button
        exitButton.enabled = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /* Add all the player text and image views to their list */
        AppWarpHelper.sharedInstance.gameRoomVC = self
        playerNames.append(p1Name)
        playerNames.append(p2Name)
        playerNames.append(p3Name)
        
        classImages.append(p1Img)
        classImages.append(p2Img)
        classImages.append(p3Img)
        
        /* Disable the start game button until RoomListenter calls configLobbyView(), since we need some data to be set in configLobbyView() before game can be started */
        
        startGameButton.enabled = false
        self.myPlayerName = AppWarpHelper.sharedInstance.playerName
    }
    
    /* ============ Player names and icons functions ============ */
    /*
        This function sends my class over the network so other ppl can set the display icon properly
    */
    func sendMyClass() {
        
        var sendClassMsg: Dictionary<String, Array<AnyObject>> = [:]
        sendClassMsg["LobbyClassIcon"] = []
        
        var myClassDict: Dictionary<String, String> = [:]
        myClassDict["ID"] = myPlayerName
        myClassDict["Class"] = myClass
        
        sendClassMsg["LobbyClassIcon"]!.append(myClassDict)
        NetworkManager.sendMsg(&sendClassMsg)
    }
    
    /*
        This funcion receives a player's class over the network and updates the icons
    */
    func updatePlayerIcons(playerClass: Dictionary<String, String>) {
        for i in 0 ..< playerNames.count {
            if playerNames[i].text == playerClass["ID"] {
                switch playerClass["Class"]! {
                    case "Warrior":
                        classImages[i].image = UIImage(named: "WarriorIcon")
                    case "Mage":
                        classImages[i].image = UIImage(named: "MageIcon")
                    case "Priest":
                        classImages[i].image = UIImage(named: "PriestIcon")
                    default:
                        println("updatePlayerIcon() found a class that has not yet been implemented")
                }
            }
        }
        
    }
    
    /* This function updates the lobby's player names and icons when ppl joins the room */
    func setPlayerNames()
    {
        /* Fill out the player names for ppl in the lobby */
        for index in 0 ..< AppWarpHelper.sharedInstance.userName_list.count
        {
            playerNames[index].text = AppWarpHelper.sharedInstance.userName_list[index] as String
            
        }
        
        /* Fill out the empty slots with empty strings and nil img */
        let maxUsers: Int = Int(AppWarpHelper.sharedInstance.maxUsers)
        
        if AppWarpHelper.sharedInstance.userName_list.count != maxUsers
        {
            for index in AppWarpHelper.sharedInstance.userName_list.count ..< maxUsers
            {
                playerNames[index].text = ""
                classImages[index].image = nil
            }
        }
        
        // don't know why stupid xcode won't just apply the old font, so have to reapply them manually
        for playerName in playerNames {
            playerName.font = playerNamesFont
            playerName.textAlignment = NSTextAlignment.Center
        }
    }
    /* =========================================================== */
    
    
    /* ================== Level Picker functions ================= */
    /*
        This function configures the level picker view & sets its delegate & data source
    */
    func configLevelPicker() {
        levelPicker.dataSource = levelDelegate
        levelPicker.delegate = levelDelegate
        
        if myPlayerName == AppWarpHelper.sharedInstance.host {
            levelPicker.userInteractionEnabled = true
        } else {
            levelPicker.userInteractionEnabled = false
        }
    }
    
    /*
        This function sends host's selected level over the network for display. It should be called
        from BOTH LevelSelection.pickerView(...didSelectRow...) (that function should only be
        called by the host program) AND configLevelPicker() (which is called from onGetLiveRoomInfoDone())
    */
    func sendPickedLevel(col: Int, row: Int) {
        var sendLevelMsg: Dictionary<String, Array<AnyObject>> = [:]
        sendLevelMsg["SelectedLevel"] = []
        
        var levelInfo: Dictionary<String, AnyObject> = [:]
        // These two values tells us the column & row index of the selected level in the picker view
        levelInfo["col"] = col
        levelInfo["row"] = row
        
        sendLevelMsg["SelectedLevel"]!.append(levelInfo)
        NetworkManager.sendMsg(&sendLevelMsg)
    }
    
    /*
        This function updates the picker view & the selected level based on what host sends over the network when host is picking levels
    */
    func updateLevelPicker(levelInfo: Dictionary<String, AnyObject>) {
        let col = levelInfo["col"] as Int
        let row = levelInfo["row"] as Int
        
        // Only need to update my picker view if i'm the client
        if myPlayerName != AppWarpHelper.sharedInstance.host {
            levelPicker.selectRow(row, inComponent: col, animated: true)
        }
    }
    
    /* =========================================================== */
    
    /*
        This function configures the lobby view based on whether you're host or not and whatever other people sent over the network (eg. their classes, host's selected level...etc).
    
        It also sets the host.
    
        For now, it is getting called from RoomListener.onGetLiveRoomInfoDone():
            RoomListener.onGetLiveRoomInforDone() -> AppWarpHelper.configGameRoomView()->GameRoomViewController.configGameRoomView()
    */
    func configGameRoomView() {
        /* print the updated user list and set host to be the first guy in that list*/
        println("Current users in the room lobby:")
        println(AppWarpHelper.sharedInstance.userName_list)
        
        // set host
        println("configLobbyView(): setting host to \(AppWarpHelper.sharedInstance.userName_list[0] as String)")
        AppWarpHelper.sharedInstance.host = (AppWarpHelper.sharedInstance.userName_list[0] as String)
        
        /* Configure the lobby view based on whether you're host or not */
        if AppWarpHelper.sharedInstance.playerName != AppWarpHelper.sharedInstance.host
        {
            // not the host
            titleText.text = "Waiting for host to start the game..."
            startGameButton.enabled = false
        }
        else
        {
            // is the host
            titleText.text = "Pick a level and start the game!"
            startGameButton.enabled = true
        }
        // don't know why stupid xcode won't just apply the old font, so have to reapply them manually
        titleText.font = titleTextFont
        titleText.textAlignment = NSTextAlignment.Center
        
        setPlayerNames()
        configLevelPicker()
        sendMyClass()
        // sending my class multiple times b/c we dont know what's causing icons to not show up sometimes
        sendMyClass()
        sendMyClass()
        sendMyClass()
        sendMyClass()
        updateNumberOfPlayers(AppWarpHelper.sharedInstance.userName_list.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNumberOfPlayers(players: Int){
        levelDelegate.updateNumberOfPlayers(levelPicker, players: players)
    }
    

}
