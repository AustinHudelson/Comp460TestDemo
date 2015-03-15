//
//  MainViewController.swift
//  460Demo
//
//  Created by Robert Ko on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mageSelectionButton: UIButton!
    @IBOutlet weak var warriorSelectionButton: UIButton!
    @IBOutlet weak var playerNameTxtField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    var selectedClass:String = "Warrior"
    
    @IBAction func mageSelectionButtonAction(sender: AnyObject) {
        
        selectedClass = "Mage"
        println(selectedClass)
        mageSelectionButton.selected = true
        warriorSelectionButton.selected = false
    }
    
    @IBAction func warriorSelectionButtonAction(sender: AnyObject) {
        selectedClass = "Warrior"
        println(selectedClass)
        mageSelectionButton.selected = false
        warriorSelectionButton.selected = true
    }
    
    @IBAction func startButtonAction(sender: AnyObject) {
        let letter = NSCharacterSet.letterCharacterSet()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var notWhitespace: Bool = false
        if countElements(playerNameTxtField.text) >= 1
        {
            for character in playerNameTxtField.text.unicodeScalars
            {
                if letter.longCharacterIsMember(character.value)
                {
                    notWhitespace = true
                    break;
                }
                else if digits.longCharacterIsMember(character.value)
                {
                    notWhitespace = true
                    break;
                }
            }
            if notWhitespace{
                println(selectedClass)
                performSegueWithIdentifier("playerNameSegue",  sender: self)
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
            set this SplashViewController to be playerNameTxtField's delegate so it can know when a user is entering text in the text field
        */
        playerNameTxtField.delegate = self
        
        /*
            If playerName is empty string or character not selected, disable the Start button
        */
        
//        if countElements(playerNameTxtField.text) < 1 {
//            startButton.enabled = false
//        }
        warriorSelectionButton.selected = true
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playerNameSegue") {
            var svc = segue.destinationViewController as LobbyTableViewController
            svc.myPlayerName = playerNameTxtField.text
            svc.myClass = selectedClass
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        - This method is called after the text field resigns its first responder status. You can use this method to update your delegate’s state information. For example, you might use this method to hide overlay views that should be visible only while editing.
    */
    func textFieldDidEndEditing(textField: UITextField) {
        
        println(textField.text)
    }
    
    

}
