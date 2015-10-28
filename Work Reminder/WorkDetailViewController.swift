//
//  WorkDetailViewController.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/19/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import UIKit
import DOCheckboxControl

class WorkDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var workName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var priorityImage: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var finishCheckbox: CheckboxControl!
    @IBOutlet weak var remindBeforeLabel: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
//    @IBOutlet weak var taskCell: ViewTaskTableViewCell!
    @IBOutlet weak var taskList: UITableView!
    var work: Work?
    let rowHeight = CGFloat(44.0)
    let contentViewBoundsSizeHeight = CGFloat(667.0)
    let contentViewBoundsOriginY = CGFloat(0.0)
    let noteTextViewFrameOriginY = CGFloat(408.0)
    let noteLabelFrameOriginY = CGFloat(379.0)
    let taskListFrameSizeHeight = CGFloat(44.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.finishCheckbox.layer.borderColor = UIColor.blackColor().CGColor
        self.finishCheckbox.layer.borderWidth = 2
        taskList.delegate = self
        taskList.dataSource = self
        taskList.rowHeight = 44.0
        if let work = self.work {
            print(self.workName.frame.origin.y)
            navigationItem.title = "Detail"
            self.workName.text = work.name
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy-HH:mm"
            self.startTime.text = dateFormatter.stringFromDate(work.startTime)
            self.toTime.text = dateFormatter.stringFromDate(work.endTime)
            self.noteTextView.text = work.note
            if (work.remindBefore == 30) {
                self.remindBeforeLabel.text = "30 minutes"
            }
            else if (work.remindBefore == 60 || work.remindBefore == 360 || work.remindBefore == 720) {
                self.remindBeforeLabel.text = "\(work.remindBefore/60) hours"
            }
            else if (work.remindBefore == 1440){
                self.remindBeforeLabel.text = "1 day"
            }
            else {
                self.remindBeforeLabel.text = "None"
            }
            self.finishCheckbox.selected = work.isFinished
            self.priorityImage.image = UIImage(named: "flag\(work.priority)")

            if work.tasks.count>1 {
                let remaintask = work.tasks.count-1
                print ("row height: \(self.taskList.frame.size.height)")
                let heightShift = CGFloat(remaintask) * self.taskList.frame.size.height
                self.contentView.bounds.size.height += (heightShift)
                self.contentView.bounds.origin.y += (heightShift/2)
                self.noteTextView.frame.origin.y += heightShift
                self.noteLabel.frame.origin.y += heightShift
                self.taskList.frame.size.height += heightShift
               
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutIfNeeded()
        
        self.scrollView.contentSize = self.contentView.bounds.size
        self.contentView.bounds.origin.y = 0.0
        self.contentView.frame.origin.y = 0.0
        print("View Did Layout")
        print(scrollView.contentSize)
        print (scrollView.frame.size)
        print (scrollView.frame.origin)
        print (self.contentView.bounds.origin)
        print (self.contentView.bounds.size)
        print(self.contentView.frame.size)
        print(self.contentView.frame.origin)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewTaskTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ViewTaskTableViewCell
        
        // Configure the cell...
        // Fetches the appropriate meal for the data source layout.
        let subtask = work!.tasks[indexPath.row]
        cell.taskName.text = subtask.name
        cell.checkBox.setSelected(subtask.status, animated: true)
        return cell
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) ->Int
    {
        return work!.tasks.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === backBtn{
            work!.isFinished = self.finishCheckbox.selected
            for row in 0..<work!.tasks.count {
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                
                if let tableCell = self.taskList.cellForRowAtIndexPath(indexPath) as? ViewTaskTableViewCell {
                    self.work!.tasks[row].status = tableCell.checkBox.selected
                    print(self.work!.priority)
                }
                
            }
        }
        if segue.identifier == "EditItem" {
            for row in 0..<work!.tasks.count {
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                
                if let tableCell = self.taskList.cellForRowAtIndexPath(indexPath) as? ViewTaskTableViewCell {
                    self.work!.tasks[row].status = tableCell.checkBox.selected
                    print(self.work!.priority)
                }
                
            }
            let viewController = segue.destinationViewController as! ViewController
            viewController.work = self.work
            
        }
        
    }
    @IBAction func unwindToMealList (sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? ViewController {
            self.work = sourceViewController.work
            self.workName.text = work!.name
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy-HH:mm"
            self.startTime.text = dateFormatter.stringFromDate(work!.startTime)
            self.toTime.text = dateFormatter.stringFromDate(work!.endTime)
            self.noteTextView.text = work!.note
            if (work!.remindBefore == 30) {
                self.remindBeforeLabel.text = "30 minutes"
            }
            else if (work!.remindBefore == 60 || work!.remindBefore == 360 || work!.remindBefore == 720) {
                self.remindBeforeLabel.text = "\(work!.remindBefore/60) hours"
            }
            else if (work!.remindBefore == 1440){
                self.remindBeforeLabel.text = "1 day"
            }
            else {
                self.remindBeforeLabel.text = "None"
            }
            self.finishCheckbox.selected = work!.isFinished
            self.priorityImage.image = UIImage(named: "flag\(work!.priority)")
            
            if work!.tasks.count>1 {
                let remaintask = work!.tasks.count-1
                print ("row height: \(self.taskList.frame.size.height)")
                let heightShift = CGFloat(remaintask) * self.rowHeight
                self.contentView.bounds.size.height = self.contentViewBoundsSizeHeight + heightShift
                self.contentView.bounds.origin.y = self.contentViewBoundsOriginY + heightShift/2
                self.noteTextView.frame.origin.y = self.noteTextViewFrameOriginY + heightShift
                self.noteLabel.frame.origin.y = self.noteLabelFrameOriginY + heightShift
                self.taskList.frame.size.height = self.taskListFrameSizeHeight + heightShift
                
            }

            for notification in (UIApplication.sharedApplication().scheduledLocalNotifications )! {
                if notification.userInfo!["Id"] as! String == "\(work!.id)" {
                    let periodComp = NSDateComponents()
                    periodComp.day = 0
                    periodComp.hour = 0
                    periodComp.minute = -work!.remindBefore
                    let calendar = NSCalendar.currentCalendar()
                    let alarmTime = calendar.dateByAddingComponents(periodComp, toDate: work!.startTime, options: [])
                    notification.fireDate = alarmTime
                    if work!.remindBefore == 60 || work!.remindBefore == 360 || work!.remindBefore == 720 {
                        notification.alertBody = "Your work \(work!.name) will begin in \(work!.remindBefore/60) hours. Get ready!"
                    }
                    else if work!.remindBefore == 1440 {
                        notification.alertBody = "Your work \(work!.name) will begin in 1 day. Get ready!"
                    }
                    else if work!.remindBefore == 30 {
                        notification.alertBody = "Your work \(work!.name) will begin in 30 minutes. Get ready!"
                    }
                    else {
                        notification.alertBody = "Your work \(work!.name) begins. Go do it!"
                    }

                    
                }
                else if notification.userInfo!["Id"] as! String == "\(work!.id)-overdue" {
                    notification.fireDate = self.work!.endTime
                }
                
            }
        }
    }

}
