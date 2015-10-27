//
//  Task.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/12/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    var name: String
    var status: Bool
    var belongToWork: Int
    struct PropertyKey {
        static let nameKey = "name"
        static let statusKey = "status"
        static let belongToWorkKey = "belongToWork"
    }
    init (name:String, status: Bool, belongToWork: Int) {
        self.name = name
        self.status = status
        self.belongToWork = belongToWork
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeBool(status, forKey: PropertyKey.statusKey)
        aCoder.encodeInteger(belongToWork, forKey: PropertyKey.belongToWorkKey)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let status = aDecoder.decodeBoolForKey(PropertyKey.statusKey)
        let belongToWork =  aDecoder.decodeIntegerForKey(PropertyKey.belongToWorkKey)
        self.init(name: name, status: status, belongToWork: belongToWork)
    }
}