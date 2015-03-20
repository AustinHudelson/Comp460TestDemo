//
//  LevelSelection.swift
//  460Demo
//
//  Created by Austin Hudelson on 3/20/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

class LevelSelection: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var levels: Array<Level> = [LevelOne(), LevelTwo(), LevelThree()]
    
    override init(){
        super.init()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return levels[row].title
    }
}