//
//  ViewTaskTableViewCell.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/19/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import UIKit
import DOCheckboxControl

class ViewTaskTableViewCell: UITableViewCell {
    

    @IBOutlet weak var checkBox: CheckboxControl!
    @IBOutlet weak var taskName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.layer.borderColor = UIColor.blackColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkBox.layer.borderColor = UIColor.blackColor().CGColor
        checkBox.layer.borderWidth = 1
//        checkBox.selected = true
//        checkBox.setSelected(true, animated: true)
        // Configure the view for the selected state

    }

}
