//
//  ViewController.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/10/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Properties
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var workName: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var periodPicker: UIPickerView!
    @IBOutlet weak var addSubtaskBtn: UIButton!
    @IBOutlet weak var priorityButtons: PriorityControl!
    
    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var taskList: UITableView!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var noteTextView: UITextView!
    
    var preparedId: Int!
    var work: Work?
    var tasks = [Task]()
    var navigatedFrom: UIViewController?
    var periods = ["Right on time","30 minutes", "1 hour", "6 hours", "12 hours", "1 day"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        taskList.delegate = self
        taskList.dataSource = self
        periodPicker.delegate = self
        taskList.setEditing(true, animated: true)
        newTaskTextField.delegate = self
        workName.delegate = self
        startTime.datePickerMode = .DateAndTime
        endTime.datePickerMode = .DateAndTime
        if (work == nil) {
            priorityButtons.priorityButtons[2].selected = true
        }
        self.taskList.allowsMultipleSelectionDuringEditing = false
//        loadSampleData()
        if let work = self.work {
            workName.text = work.name
            startTime.date = work.startTime
            endTime.date = work.endTime
            if (work.remindBefore == 0) {
                self.periodPicker.selectRow(0, inComponent: 0, animated: true)
            }
            else if (work.remindBefore == 30) {
                self.periodPicker.selectRow(1, inComponent: 0, animated: true)
            }
            else if (work.remindBefore == 60) {
                self.periodPicker.selectRow(2, inComponent: 0, animated: true)
            }
            else if (work.remindBefore == 360) {
                self.periodPicker.selectRow(3, inComponent: 0, animated: true)
            }
            else if (work.remindBefore == 720) {
                self.periodPicker.selectRow(4, inComponent: 0, animated: true)
            }
            else if (work.remindBefore == 1440) {
                self.periodPicker.selectRow(5, inComponent: 0, animated: true)
            }
            priorityButtons.priorityButtons[work.priority].selected = true
            self.tasks = work.tasks
            self.noteTextView.text = work.note
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = self.contentView.bounds.size
    }
    
    func loadSampleData(){
        let task1 = Task(name: "Task 1", status: false, belongToWork: 0)
        let task2 = Task(name: "Task 2", status: false, belongToWork: 0)
        let task3 = Task(name: "Task 3", status: false, belongToWork: 0)
        let task4 = Task(name: "Task 4", status: false, belongToWork: 0)
        let task5 = Task(name: "Task 5", status: false, belongToWork: 0)
        tasks += [task1, task2, task3, task4, task5]
        
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SubtaskTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SubtaskTableViewCell
        
        // Configure the cell...
        // Fetches the appropriate meal for the data source layout.
        let subtask = tasks[indexPath.row]
        cell.taskName.text = subtask.name
//        cell.deleteBtn.addTarget(tableView, action: "deleteButtonPressed", forControlEvents: .TouchUpInside)
        return cell
        
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) ->Int
    {
        return tasks.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
//    func deleteButtonPressed (sender: UIButton!, indexPathRow: Int , tableView: UITableView) {
//        
//    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.workName.resignFirstResponder()
        self.newTaskTextField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        self.addSubtaskBtn.enabled = false
    }
    func checkValidTaskName() {
        // Disable the Save button if the text field is empty.
        let text = newTaskTextField.text ?? ""
        self.addSubtaskBtn.enabled = !text.isEmpty
    }
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidTaskName()
    }
    

    // MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.periods.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.periods[row]
    }
    // MARK: Actions
    
    @IBAction func addNewSubtaskBtn_TouchUpInside(sender: UIButton) {
        let task = Task(name: self.newTaskTextField.text!, status: false, belongToWork: 0)
        tasks.append(task)
        taskList.reloadData()
        self.newTaskTextField.text=nil
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddWorkMode = presentingViewController is UINavigationController
        if isPresentingInAddWorkMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    // MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBtn === sender {
            let name = workName.text
            let from = startTime.date
            let to = endTime.date
            var priority = 0
            for k in 0..<self.priorityButtons.priorityButtons.count {
                if self.priorityButtons.priorityButtons[k].selected == true {
                    priority = k
                }
            }
            let mytasks = self.tasks
            let note = self.noteTextView.text
            var period = 0
            let periodValue = periods[self.periodPicker.selectedRowInComponent(0)]
            
            
            if (periodValue == "30 minutes") {
                period = 30
            }
            else if (periodValue == "1 hour") {
                period = 60
            }
            else if (periodValue == "6 hours") {
                period = 360
            }
            else if (periodValue == "12 hours") {
                period = 720
            }
            else if (periodValue == "1 day") {
                period = 1440
            }
            var isFinished = false
            if (self.work != nil) {
                isFinished = self.work!.isFinished
            }
            self.work = Work (id: 0, name: name!,startTime: from, endTime: to, priority: priority, note: note, tasks: mytasks, remindBefore: period, isFinished: isFinished)
            
        }
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // check if it is valid to save
        if saveBtn === sender{
            if self.workName.text == "" || self.workName.text!.isEmpty == true{
                return false
            }

            if startTime.date.compare(endTime.date) == .OrderedAscending {
                return true
            }
            else {
                return false
            }
                    }
        return true
    }
}

