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
    var myPlayerName: String = ""
    
    @IBOutlet weak var startButton: UIButton!
    
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
        AppWarpHelper.sharedInstance.connectWithAppWarpWithUserName(myPlayerName)
        println("Completed connection w/ username = \(myPlayerName)")
        
        AppWarpHelper.sharedInstance.lobby = self
    }
    
    func updateUserList() {
        println(AppWarpHelper.sharedInstance.userName_list)
    }
    
    @IBAction func startButtonAction(sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
