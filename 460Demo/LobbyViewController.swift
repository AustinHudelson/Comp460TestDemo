//
//  LobbyViewController.swift
//  460Demo
//
//  Created by Robert Ko on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit
import SpriteKit

class LobbyViewController: UIViewController {
    var myPlayerName: String? = nil
    var myClass: String = ""
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var p1Name: UITextView!
    @IBOutlet weak var p2Name: UITextView!
    @IBOutlet weak var p3Name: UITextView!
    @IBOutlet weak var p4Name: UITextView!
    
    @IBOutlet weak var p1Img: UIImageView!
    @IBOutlet weak var p2Img: UIImageView!
    @IBOutlet weak var p3Img: UIImageView!
    @IBOutlet weak var p4Img: UIImageView!
    @IBOutlet weak var levelPicker: UIPickerView!
    
    let levelDelegate: LevelSelection = LevelSelection()
    
    var classImages: Array<UIImageView> = Array<UIImageView>()
    var playerNames: Array<UITextView> = Array<UITextView>()
    
    @IBAction func startGameButtonAction(sender: AnyObject) {
        if myPlayerName != nil && myPlayerName == AppWarpHelper.sharedInstance.host {
            /*
                Send a msg to AppWarp to tell everyone to start the game.
                The game won't start until everyone receives this message.
            */
            var startGameMsg: Dictionary<String, Array<AnyObject>> = [:]
            startGameMsg["Start Game!"] = []
            NetworkManager.sendMsg(&startGameMsg)
        } else {
            println("You need to wait for host to start the game!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*
            Initalize AppWarp
            - sharedInstance seems to be a way to get diff swift class/files to talk to the same (AppWarp) obj
            - sharedInstance IS A SINGLETON, which means it's an obj that is created once & has its state shared:
            http://thatthinginswift.com/singletons/
        */
        AppWarpHelper.sharedInstance.initializeWarp()
        
        println("Finished initializing AppWarp")
        
        println("Now connecting w/ username = \(myPlayerName)")
        AppWarpHelper.sharedInstance.connectWithAppWarpWithUserName(myPlayerName!)
        println("Completed connection w/ username = \(myPlayerName)")
        
        AppWarpHelper.sharedInstance.lobby = self
        AppWarpHelper.sharedInstance.playerClass = myClass
        playerNames.append(p1Name)
        playerNames.append(p2Name)
        playerNames.append(p3Name)
        playerNames.append(p4Name)
        
        classImages.append(p1Img)
        classImages.append(p2Img)
        classImages.append(p3Img)
        classImages.append(p4Img)
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
                        classImages[i].image = UIImage(named: "Warrior Icon")
                    case "Mage":
                        classImages[i].image = UIImage(named: "Mage Icon")
                    default:
                        println("updatePlayerIcon() found a class that has not yet been implemented")
                }
            }
        }
    }
    
    func setPlayerNames()
    {
        for index in 0 ..< AppWarpHelper.sharedInstance.userName_list.count
        {
            playerNames[index].text = AppWarpHelper.sharedInstance.userName_list[index] as String
            
        }
        if AppWarpHelper.sharedInstance.userName_list.count != 4
        {
            for index in AppWarpHelper.sharedInstance.userName_list.count ..< 4
            {
                playerNames[index].text = ""
                classImages[index].image = nil
            }
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
        
        // default the level to Level One. Need to do this because we only handle changing levels when the host sends the level msg over the network (i.e. in updateLevelPicker)
        Game.global.level = levelDelegate.levels[0]
    }
    
    /*
        This function sends host's selected level over the network. It will be called
        from LevelSelection.pickerView(...didSelectRow...), and that function should only be
        called by the host program
    */
    func sendPickedLevel(levelTxt: String, col: Int, row: Int) {
        var sendLevelMsg: Dictionary<String, Array<AnyObject>> = [:]
        sendLevelMsg["SelectedLevel"] = []
        
        var levelInfo: Dictionary<String, AnyObject> = [:]
        levelInfo["levelTxt"] = levelTxt
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
        let levelTxt = levelInfo["levelTxt"] as String
        let col = levelInfo["col"] as Int
        let row = levelInfo["row"] as Int
        
        // set the level
        switch levelTxt {
            case "Level One":
                Game.global.level = levelDelegate.levels[0]
            case "Level Two":
                Game.global.level = levelDelegate.levels[1]
            case "Level Three":
                Game.global.level = levelDelegate.levels[2]
            default:
                println("updateLevelPicker found an unrecognized level \"\(levelTxt)\" in levelInfo")
        }
        
        // Only need to update my picker view if i'm the client
        if myPlayerName != AppWarpHelper.sharedInstance.host {
            levelPicker.selectRow(row, inComponent: col, animated: true)
        }
    }
    
    /* =========================================================== */
    
    /*
        This function configures the lobby view based on whether you're host or not and whatever other people sent over the network (eg. their classes, host's selected level...etc).
    
        It also sets the host.
    
        For now, it is getting called from RoomListener.onGetLiveRoomInforDone():
            RoomListener.onGetLiveRoomInforDone() -> AppWarpHelper.configLobbyView()->LobbyViewController.configLobbyView9)
    */
    func configLobbyView() {
        /* print the updated user list and set host to be the first guy in that list*/
        println("Current users in the room lobby:")
        println(AppWarpHelper.sharedInstance.userName_list)
        
        // set host
        AppWarpHelper.sharedInstance.host = (AppWarpHelper.sharedInstance.userName_list[0] as String)
        
        /* Configure the lobby view based on whether you're host or not */
        if AppWarpHelper.sharedInstance.playerName != AppWarpHelper.sharedInstance.host
        {
            startGameButton.enabled = false
        }
        else
        {
            startGameButton.enabled = true
        }
        
        setPlayerNames()
        configLevelPicker()
        sendMyClass()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
