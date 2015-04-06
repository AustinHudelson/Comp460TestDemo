//
//  FileManager.swift
//  460Demo
//
//  Created by Robert Ko on 4/1/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import Foundation

class FileManager {
    
    var fileCreated: Bool = false
    var saveFileName: String = "savedGameData"
    
    func getFileURL() -> NSURL? {
        var error: NSError?
        var fileUrl: NSURL? = nil
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        var fileDir: NSURL? = fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: &error)
        
        if fileDir != nil {
            // find our savedGameData file
            fileUrl = fileDir!.URLByAppendingPathComponent(saveFileName)
        } else {
            println("!!!!Error in getting URL for \(saveFileName)!!!!")
            println(error)
        }
        
        return fileUrl
    }
    
    /*
        This function sets up the FileManager by creating a file if it doesn't exist.
        It needs to be called before loadGameData() & saveGameData() can be used!!!
    */
    func initialize() {
        let fileUrl: NSURL = getFileURL()!
        
        /* If file doesnt exist, create one by saving junk data */
        if !fileUrl.checkResourceIsReachableAndReturnError(nil) {
            println("The file \(saveFileName) does not exist! Creating a new \(saveFileName) by first saving junk data onto it (this can be overwritten later in subsequent saves)")
            saveGameData()
        }
        fileCreated = true
        
//        let filePath: String = fileUrl.absoluteString!
//        
//        /* Create the savedGameData file if it doesn't exist */
//        if !fileManager.fileExistsAtPath(filePath) {
//            let blankStr: String = ""
//            let data: NSData = blankStr.dataUsingEncoding(NSUTF8StringEncoding)!
//            
//            println("File created")
//            fileManager.createFileAtPath(filePath, contents: data, attributes: nil)
//        }
//        fileCreated = true
    }
    
    func loadGameData() {
        let fileUrl: NSURL = getFileURL()!
        
        if !fileCreated {
            println("!!!!Error in saveGameData(): trying to save to file before calling FileManager.initialize()!!!!")
            return
        }
        
        var readError: NSError?
        /*
            NSDataReadingOptions values:
            - DataReadingUncached: A hint indicating that the file should not be stored in the file-system chaches.
            This helps performance if you're only reading the file once
        */
        if let savedData: NSData = NSData(contentsOfURL: fileUrl, options: .DataReadingUncached, error: &readError) {
            
            // This is a temporary variable that stores the contents read from file
            let pGameData: PersistGameData = NSKeyedUnarchiver.unarchiveObjectWithData(savedData) as PersistGameData
            
            /* Set the values in our PersistGameData object based on what was read from the file */
            println("===Loaded Game Data:===")
            println(pGameData)
            PersistGameData.sharedInstance.myPlayerName = pGameData.myPlayerName
            
        } else {
            println("!!!!Error in reading \(fileUrl)!!!!")
            println(readError)
        }
    }
    
    func saveGameData() {
        let pGameData: PersistGameData = PersistGameData.sharedInstance
        let fileUrl: NSURL = getFileURL()!
        
        println("===Saving Game Data:===")
        println(pGameData)

        /* Archive our PersistGameData object into NSData */
        let savedData: NSData = NSKeyedArchiver.archivedDataWithRootObject(pGameData)
        
        /* Save archived data to file */
        savedData.writeToURL(fileUrl, atomically: true)
    }
}