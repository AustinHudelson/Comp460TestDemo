//
//  GameLobbyTableViewController.swift
//  460Demo
//
//  Created by Robert Ko on 6/29/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit

class GameLobbyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var myPlayerName: String? = nil
    var myClass: String = ""
    var rooms: Array<AnyObject>? = nil
    var selectedRow: Int? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func createGameAction(sender: AnyObject) {
        // Create a room name with roomName = playerName & maxUsers = roomMaxUsers
        let playerName = AppWarpHelper.sharedInstance.playerName
        let maxUsers = AppWarpHelper.sharedInstance.maxUsers
        AppWarpHelper.sharedInstance.createRoom(playerName, maxUsers: maxUsers)
    }
   
    
    @IBAction func joinGameAction(sender: AnyObject) {
        if selectedRow == nil
        {
            println("Selected Row:\(selectedRow)")
        }

        if rooms == nil
        {
            println("rooms is new")
        }
        println("hello")
        if selectedRow != nil && rooms != nil
        {

            let joinRoomID = rooms![selectedRow!].roomId
            println(joinRoomID)
            WarpClient.getInstance().joinRoom(joinRoomID)

            println("====Going from RoomSelection to Game Lobby====")

            performSegueWithIdentifier("RoomSelectionToGameLobby",  sender: self)
            
            
        }
    }
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            Initalize AppWarp
            - sharedInstance seems to be a way to get diff swift class/files to talk to the same (AppWarp) obj
            - sharedInstance IS A SINGLETON, which means it's an obj that is created once & has its state shared:
            http://thatthinginswift.com/singletons/
        */
        
        AppWarpHelper.sharedInstance.gameLobbyVC = self
        AppWarpHelper.sharedInstance.initializeWarp()
        println("Finished initializing AppWarp")
        
        println("Now connecting w/ name = \(myPlayerName!)")
        AppWarpHelper.sharedInstance.connectWithAppWarpWithUserName(myPlayerName!)
        println("Completed connection w/ name = \(myPlayerName!)")
        
        AppWarpHelper.sharedInstance.playerClass = myClass
        tableView.delegate = self
        self.tableView.reloadData()
        //self.

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //added by Olyver
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if tableView.indexPathForSelectedRow() != nil
//        {
//            showSelected.text = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow()!)!.textLabel!.text
//            println("something selected")
//        }
//    }
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    println("in selection")
        if tableView.indexPathForSelectedRow() != nil
        {
            println(tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow()!)!.textLabel!.text)
            println("something selected")
            self.selectedRow = indexPath.row
        }
    }
    
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {
        println("1")
        return 1
    }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int
    {
        println("\(rooms?.count)")
        if rooms == nil{return 1}
        
        return rooms!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        println(indexPath.row)
        if(rooms == nil)
        {
            println("room is nil")
        }
        if(rooms != nil && rooms!.count > indexPath.row)
        {
            
            cell.textLabel?.text = rooms![indexPath.row].owner!
            println("putting stuff in the table")
            
        }
        else
        {
            cell.textLabel?.text = ""
        }
        println("input text into table")
        return cell
        
    }
    
    func updateRooms(){
        
        
        
    }
}
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */


