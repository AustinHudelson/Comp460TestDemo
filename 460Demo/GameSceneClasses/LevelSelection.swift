//
//  LevelSelection.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/20/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

/*
    This object takes care of receiving which level the host picks in lobby and set up the Game scene with the picked level
*/
class LevelSelection: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    // This variable is ONLY used for displaying the level texts in lobby
    var allLevels: Array<Array<Level>> = [[LevelOne1(), LevelTwo1(), LevelThree1(), LevelFour1(), LevelFive1()], [LevelOne2(), LevelTwo2(), LevelThree2(), LevelFour2(), LevelFive2()], [LevelOne3(), LevelTwo3(), LevelThree3(), TwoChampions(), CavernOfTheEvilWizard()]]
    var levelsDataSource: Array<Level> = [LevelOne1(), LevelTwo1(), LevelThree1(), LevelFour1(), LevelFive1()]
    
    
    /*
        This dictionary contains the actual Level objects that we will need in Game.swift
        For now, we will have one column that just shows which level it is:
            Eg.
                Level One
                Level Two
                Level Three
        The reason we have a dictionary is because within each level, we have sublevels which are loaded depending on number of players in the game
    */
    var levels: Dictionary<String, Array<Level>> = [:]
    var numSubLevels = 3
    
    /*
        Number of columns in this picker viewer.
    */
    var numCols: Int = 1
    
    /*
         Number of rows within a column, which just corresponds to number of levels in the game
    */
    var numRows: Int {
        get {
            return levelsDataSource.count
        }
    }
    
    
    override init(){
        super.init()
        
//        /* Initialize the keys and arrays in our "levels" variable */
//        for levelTxt in levelTitles {
//            var noSpace: String = removeWhiteSpaces(levelTxt) // get rid of white spaces in levelTxt so we can go from a string to a class
//            levels[noSpace] = []
//        }
//        
//        /* Initialize sublevels here */
//        for (levelTxt, levelArray) in levels {
//            for i in 1...numSubLevels {
//                var noSpace: String = removeWhiteSpaces(levelTxt) // get rid of white spaces in levelTxt so we can go from a string to a class
//                noSpace += i.description
//                
//                /* Go from a string to its corresponding level class */
//                var anyObjType: AnyObject.Type = NSClassFromString(noSpace)
//                var levelType: Level.Type = anyObjType as Level.Type
//                var newLevel: Level = levelType()
//                
//                /* put this new level obj into our levels dictionary */
//                levels[noSpace]!.append(newLevel)
//            }
//        }
    }
    
    /* The picker view will call this function to get the number of columns in the picker */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        // We only have 1 column for our level picker in lobby
        return numCols
    }
    
    /* The picker view will call this function to get the number of rows in a column */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // We'll have picker's number rows = number of levels
        return numRows
    }
    
    /* The picker view will call this function to get the text for each row */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return levelsDataSource[row].title
    }
    
    /* This listener function will be called when the user changes the level selection from the picker view */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*
            If you're the host, you can interact with the pickerview to select a level. You send a msg over the network telling other ppl what you selected, and other ppl's program will automatically select whatever you selected
        */
        if AppWarpHelper.sharedInstance.playerName == AppWarpHelper.sharedInstance.host {
            if let lobby = AppWarpHelper.sharedInstance.gameRoomVC {
                lobby.sendPickedLevel(component, row: row)
            }
        }
    }
    
    func updateNumberOfPlayers(pickerView: UIPickerView, players: Int){
        levelsDataSource = allLevels[min(players-1, 2)]
        pickerView.reloadAllComponents()
    }
}