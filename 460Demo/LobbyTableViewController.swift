//
//  LobbyViewController.swift
//  460Demo
//
//  Created by Robert Ko on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit
import SpriteKit

class LobbyTableViewController: UITableViewController {
    var myPlayerName: String? = nil
    var myClass: String = ""
    
    @IBOutlet weak var cell1: UITableViewCell!
    
    @IBOutlet weak var startGameButton: UIButton!
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
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell1",forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = "Hello"
        
        return cell
        
    }
    func updateUserList()
    { /* print the updated user list and set host to be the first guy in that list*/
        println("Current users in the room lobby:")
        println(AppWarpHelper.sharedInstance.userName_list)
        
        AppWarpHelper.sharedInstance.host = (AppWarpHelper.sharedInstance.userName_list[0] as String) // designate host
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
