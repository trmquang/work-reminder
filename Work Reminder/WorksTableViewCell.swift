//
//  WorksTableViewCell.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/14/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import UIKit
import DOCheckboxControl
class WorksTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var priority: UIImageView!
    
    @IBOutlet weak var checkBox: CheckboxControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkBox.layer.borderColor = UIColor.blackColor().CGColor
        checkBox.layer.borderWidth = 1
        // Configure the view for the selected state
    }

}
