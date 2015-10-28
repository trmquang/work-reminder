//
//  WorksTableViewController.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/14/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import UIKit

class WorksTableViewController: UITableViewController {
    // MARK: Properties
    static var works = [Work]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let savedWork = self.loadWorks() {
            WorksTableViewController.works += savedWork
        }
        UIApplication.sharedApplication().scheduledLocalNotifications = []
        
    }
    // TODO: Generate new Id for new work
    static func generateNewId() -> Int {
        if WorksTableViewController.works.count == 0{
            return 0
        }
        var i = 0
        for work in WorksTableViewController.works {
            if work.id > i{
                i = work.id
            }
        }
        return i+1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WorksTableViewController.works.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorksTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorksTableViewCell
        
        // Configure the cell...
        // Fetches the appropriate meal for the data source layout.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy-HH:mm"
        let work = WorksTableViewController.works[indexPath.row]
        cell.name.text = work.name
        cell.from.text = dateFormatter.stringFromDate(work.startTime)
        cell.to.text = dateFormatter.stringFromDate(work.endTime)
        cell.priority.image = UIImage(named: "flag\(work.priority)")
        cell.checkBox.selected = work.isFinished
        // if work is overdue , text name color change to red
        if (work.isOverdue == true) {
            cell.name.textColor = UIColor.redColor()
        }
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

   
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let id = WorksTableViewController.works[indexPath.row]
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications!  {
                if notification.userInfo!["Id"] as! String == "\(id)" || notification.userInfo!["Id"] as! String == "\(id)-overdue" {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
            WorksTableViewController.works.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveWorks()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "ShowDetail" {
            let workDetailViewController = segue.destinationViewController as! WorkDetailViewController
            if let selectedWorkCell = sender as? WorksTableViewCell {
                let indexPath = tableView.indexPathForCell( selectedWorkCell)!
                let selectedWork = WorksTableViewController.works[indexPath.row]
                workDetailViewController.work = selectedWork
            }
            
        }
//        else if segue.identifier == "AddItem" {
//            let controller = segue.destinationViewController as! ViewController
//            controller.navigatedFrom = segue.sourceViewController
//        }
        

    }
    // MARK: NSCoding
    func saveWorks(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(WorksTableViewController.works, toFile: Work.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save works...")
        }
    }
    func loadWorks() -> [Work]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Work.ArchiveURL.path!) as? [Work]
    }
    // MARK: Action
    @IBAction func unwindFromViewDetail (sender: UIStoryboardSegue) {
        // Update existing Work
        if let sourceViewController = sender.sourceViewController as? WorkDetailViewController , work = sourceViewController.work {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                WorksTableViewController.works[selectedIndexPath.row] = work
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }

        }
        saveWorks()
    }
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // Add a new Work
        if let sourceViewController = sender.sourceViewController as? ViewController, work = sourceViewController.work {
            let newIndexPath = NSIndexPath(forRow: WorksTableViewController.works.count, inSection: 0)
            work.id = WorksTableViewController.generateNewId()
            for task in work.tasks {
                task.belongToWork = work.id
            }
            WorksTableViewController.works.append(work)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            // set up time period to minus
            let periodComp = NSDateComponents()
            periodComp.day = 0
            periodComp.hour = 0
            periodComp.minute = -work.remindBefore
            print(periodComp)
            let calendar = NSCalendar.currentCalendar()
            let alarmTime = calendar.dateByAddingComponents(periodComp, toDate: work.startTime, options: [])
            
            // create new start notification
            let noti = UILocalNotification()
            noti.fireDate = alarmTime
            print(noti.fireDate)
            if work.remindBefore == 60 || work.remindBefore == 360 || work.remindBefore == 720 {
                noti.alertBody = "Your work \(work.name) will begin in \(work.remindBefore/60) hours. Get ready!"
            }
            else if work.remindBefore == 1440 {
                noti.alertBody = "Your work \(work.name) will begin in 1 day. Get ready!"
            }
            else if work.remindBefore == 30 {
                noti.alertBody = "Your work \(work.name) will begin in 30 minutes. Get ready!"
            }
            else {
                noti.alertBody = "Your work \(work.name) begins. Do it now!"
            }
            noti.alertAction = "open"
            noti.soundName = UILocalNotificationDefaultSoundName
            noti.userInfo = ["Id": "\(work.id)"]
            noti.category = "WORK_REMINDER_StartWork"
            UIApplication.sharedApplication().scheduleLocalNotification(noti)
            
            // create new overdue notification
            let overduenoti = UILocalNotification()
            overduenoti.fireDate = work.endTime
            overduenoti.alertBody = "Your work \(work.name) is overdue"
            overduenoti.alertAction = "open"
            overduenoti.soundName = UILocalNotificationDefaultSoundName
            overduenoti.userInfo = ["Id": "\(work.id)-overdue"]
            overduenoti.category = "WORK_REMINDER_Overdue"
            UIApplication.sharedApplication().scheduleLocalNotification(overduenoti)
            print(UIApplication.sharedApplication().scheduledLocalNotifications!.count)
            
        }
        saveWorks()

    }
    


}
