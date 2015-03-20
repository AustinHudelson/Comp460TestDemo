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
    @IBOutlet weak var LevelSelect: UIPickerView!
    
    let levels: LevelSelection = LevelSelection()
    
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
        println(myClass)
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
        
        setLevelText()
    }
    func setLevelText() {
        LevelSelect.dataSource = levels
        LevelSelect.delegate = levels
    }
    func sendMyClass() {
        /* Send my class over the network so other ppl can set the display icon properly */
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
    func updateUserList() {
        /* print the updated user list and set host to be the first guy in that list*/
        println("Current users in the room lobby:")
        println(AppWarpHelper.sharedInstance.userName_list)
        
        AppWarpHelper.sharedInstance.host = (AppWarpHelper.sharedInstance.userName_list[0] as String) // designate host
        if AppWarpHelper.sharedInstance.playerName != AppWarpHelper.sharedInstance.host
        {
            startGameButton.enabled = false
        }
        else
        {
            startGameButton.enabled = true
        }
        
        setPlayerNames()
        sendMyClass()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
