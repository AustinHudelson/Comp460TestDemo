//
//  MainViewController.swift
//  460Demo
//
//  Created by Robert Ko on 2/15/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit

class CharSelViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var warSelButton: UIButton!
    @IBOutlet weak var mageSelButton: UIButton!
    @IBOutlet weak var priestSelButton: UIButton!
    
    @IBOutlet weak var playerNameTxtField: UITextField!
    
    var selectedClass:String = "Warrior"
    
    @IBAction func warSelButtonAction(sender: AnyObject) {
        selectedClass = "Warrior"
        warSelButton.selected = true
        mageSelButton.selected = false
        priestSelButton.selected = false
    }
    
    @IBAction func mageSelButtonAction(sender: AnyObject) {
        selectedClass = "Mage"
        warSelButton.selected = false
        mageSelButton.selected = true
        priestSelButton.selected = false
    }
    
    @IBAction func priestSelButtonAction(sender: AnyObject) {
        selectedClass = "Priest"
        warSelButton.selected = false
        mageSelButton.selected = false
        priestSelButton.selected = true
    }
    
    @IBAction func connectButtonAction(sender: AnyObject) {
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
                
                println("====Going from Char Select to Game Lobby====")
                
                performSegueWithIdentifier("CharSelectToRoomSelection",  sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameTxtField.delegate = self
        
        warSelButton.selected = true
        
        println(UIDevice.currentDevice().identifierForVendor.UUIDString)
        
        /* Initialize FileMangager to get the save game data file path. If it doesn'dt create one, this initialize function will create it */
        Game.global.fileManager = FileManager()
        Game.global.fileManager!.initialize()
        
        /* Load myPlayerName from file */
        Game.global.fileManager!.loadGameData()
        playerNameTxtField.text = PersistGameData.sharedInstance.myPlayerName
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CharSelectToRoomSelection") {
            /* On preparing for segue into lobby screen, set & save the player name to file */
            PersistGameData.sharedInstance.myPlayerName = playerNameTxtField.text
            Game.global.fileManager!.saveGameData()
            
            /* Set the player name and class variables */
            let navVC = segue.destinationViewController as UINavigationController
            let dVC: GameLobbyTableViewController = navVC.viewControllers.first as GameLobbyTableViewController
            //var svc = segue.destinationViewController as LobbyViewController
            
            dVC.myPlayerName = playerNameTxtField.text
            dVC.myClass = selectedClass
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
    @IBAction func unwindToCharSelect(segue: UIStoryboardSegue)
    {
    
    }
}
