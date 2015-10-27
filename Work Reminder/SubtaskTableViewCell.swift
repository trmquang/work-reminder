//
//  SubtaskTableViewCell.swift
//  Work Reminder
//
//  Created by Quang Minh Trinh on 10/13/15.
//  Copyright © 2015 Quang Minh Trinh. All rights reserved.
//

import UIKit

class SubtaskTableViewCell: UITableViewCell {
    // MARK: Properties

    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
