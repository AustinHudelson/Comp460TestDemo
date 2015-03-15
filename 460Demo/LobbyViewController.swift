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
    @IBOutlet weak var characterOneClass: UITextView!
    @IBOutlet weak var characterOneName: UITextView!
    @IBOutlet weak var characterOneImage: UIImageView!
    
    
    @IBOutlet weak var characterTwoName: UITextView!
    @IBOutlet weak var characterTwoImage: UIImageView!
    @IBOutlet weak var characterFourName: UITextView!
    
    @IBOutlet weak var characterFourImage: UIImageView!
    @IBOutlet weak var characterThreeImage: UIImageView!
    @IBOutlet weak var characterThreeName: UITextView!
    var classText: Array<UITextView> = Array<UITextView>()
    var classImages: Array<UIImageView> = Array<UIImageView>()
    var playerNames: Array<UITextView> = Array<UITextView>()
    
    
    
    @IBAction func startGameButtonAction(sender: AnyObject) {
        if myPlayerName != nil && myPlayerName == AppWarpHelper.sharedInstance.host {
            /*
                Send a msg to AppWarp to tell everyone to start the game.
                The game won't start until everyone receives this message.
            */
            AppWarpHelper.sharedInstance.sendStartGame()
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
        playerNames.append(characterOneName)
        playerNames.append(characterTwoName)
        playerNames.append(characterThreeName)
        playerNames.append(characterFourName)
        
        classImages.append(characterOneImage)
        classImages.append(characterTwoImage)
        classImages.append(characterThreeImage)
        classImages.append(characterFourImage)
        
        println(classImages.count)
        println(playerNames.count)
        setIcons()
        
        
        println("button state \(startGameButton.enabled)")
        
    }
    
    func setIcons()
    {
        println("Icons")
        for index in 0 ..< AppWarpHelper.sharedInstance.userName_list.count
        {
            println(index)
            playerNames[index].text = AppWarpHelper.sharedInstance.userName_list[index] as String
            classImages[index].image = UIImage(named: "Warrior Icon")
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
            println(AppWarpHelper.sharedInstance.playerName)
            println(AppWarpHelper.sharedInstance.host)
            startGameButton.enabled = false
        }
        else
        {
            startGameButton.enabled = true
        }
        
        setIcons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
