//
//  MainViewController.swift
//  460Demo
//
//  Created by Robert Ko on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var playerNameTxtField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
            If playerName is empty string or character not selected, disable the Start button
        */
        
        if countElements(playerNameTxtField.text) < 1 {
            startButton.enabled = false
        }
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playerNameSegue") {
            var svc = segue.destinationViewController as LobbyViewController
            svc.myPlayerName = playerNameTxtField.text
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
