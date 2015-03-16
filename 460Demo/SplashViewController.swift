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
        
        playerNameTxtField.delegate = self
        
        //PRELOAD GAME TEXTURE ATLASES
        TextureLoader.global.preload()
        warriorSelectionButton.selected = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playerNameSegue") {
            var svc = segue.destinationViewController as LobbyViewController
            svc.myPlayerName = playerNameTxtField.text
            svc.myClass = selectedClass
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
