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
    var levels: Array<Level> = [LevelOne(), LevelTwo(), LevelThree()]
    
    override init(){
        super.init()
    }
    
    /* The picker view will call this function to get the number of columns in the picker */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        // We only have 1 column for our level picker in lobby
        return 1
    }
    
    /* The picker view will call this function to get the number of rows in a column */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // We'll have picker's number rows = number of levels
        return levels.count
    }
    
    /* The picker view will call this function to get the text for each row */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return levels[row].title
    }
    
    /* This listener function will be called when the user changes the level selection from the picker view */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("[c,r]: [\(component), \(row)]")
    }
}