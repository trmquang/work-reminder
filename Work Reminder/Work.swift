//
//  Work.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/12/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import Foundation

class Work: NSObject, NSCoding {
    // MARK: Properties
    var id: Int
    var name: String
    var startTime: NSDate
    var endTime:NSDate
    var priority: Int
    var note: String
    var tasks:[Task]
    var remindBefore: Int
    var isOverdue: Bool {
        return (NSDate().compare(self.endTime) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
    // MARK: Archiving Path
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("works")
    //Mark: Types
    struct PropertyKey {
        static let idKey = "id"
        static let nameKey = "name"
        static let startTimeKey = "startTime"
        static let endTimeKey = "endTime"
        static let priorityKey = "priority"
        static let noteKey = "note"
        static let tasksKey = "tasks"
        static let remindBeforeKey = "remindBefore"
        static let tasksCountKey = "taskCount"
    }
    
    // Mark: Initialization
    init?(id: Int, name: String, startTime:NSDate, endTime:NSDate, priority:Int, note:String, tasks: [Task], remindBefore: Int){
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.priority = priority
        self.note = note
        self.tasks = tasks
        self.remindBefore = remindBefore
        super.init()
        // Initialization should fail if there is no name or if the rating is negative.
        if self.name.isEmpty || self.priority < 0 {
            return nil
        }
        
    }
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeInteger(id, forKey: PropertyKey.idKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(startTime, forKey: PropertyKey.startTimeKey)
        aCoder.encodeObject(endTime, forKey: PropertyKey.endTimeKey)
        aCoder.encodeInteger(priority, forKey: PropertyKey.priorityKey)
        aCoder.encodeObject(note, forKey: PropertyKey.noteKey)
        aCoder.encodeInteger(tasks.count, forKey: PropertyKey.tasksCountKey)
        for index in 0..<tasks.count {
            aCoder.encodeObject(tasks[index])
        }
        aCoder.encodeInteger(remindBefore, forKey:PropertyKey.remindBeforeKey)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeIntegerForKey(PropertyKey.idKey)
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let startTime = aDecoder.decodeObjectForKey(PropertyKey.startTimeKey) as! NSDate
        let endTime = aDecoder.decodeObjectForKey(PropertyKey.endTimeKey)as! NSDate
        let priority = aDecoder.decodeIntegerForKey(PropertyKey.priorityKey)
        let note = aDecoder.decodeObjectForKey(PropertyKey.noteKey) as! String
        let tasksCount = aDecoder.decodeIntegerForKey(PropertyKey.tasksCountKey)
        var tasks = [Task]()
        for _ in 0..<tasksCount {
            if let task = aDecoder.decodeObject() as? Task {
                tasks.append(task)
            }
        }
        let remindBefore = aDecoder.decodeIntegerForKey(PropertyKey.remindBeforeKey)
        self.init(id: id, name: name, startTime: startTime, endTime:endTime, priority: priority, note: note, tasks: tasks, remindBefore: remindBefore)
        
    }
    


    // MARK: Methods
    func addTasks(task: Task) {
        tasks.append(task)
    }
    

}