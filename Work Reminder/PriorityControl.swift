//
//  PriorityControl.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/26/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit

class PriorityControl: UIView {
    // MARK: Properties
    
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var priorityButtons = [UIButton]()
    var spacing = 5
    var flags = 3
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for i in 0..<3 {
            let button = UIButton()
            let flagImage = UIImage (named: "flag\(i)")
            let selectedFlagImage = UIImage (named :"selectedFlag\(i)")
            button.setImage(flagImage, forState: .Normal)
            button.setImage(selectedFlagImage, forState: .Selected)
            button.setImage(selectedFlagImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "priorityButtonTapped:", forControlEvents: .TouchDown)
            priorityButtons += [button]
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in priorityButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        //updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * flags
        
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    
    func priorityButtonTapped(button: UIButton) {
        rating = priorityButtons.indexOf(button)! + 1
        button.selected=true
        for(_, otherbutton) in priorityButtons.enumerate()
        {
            if (otherbutton != button){
                otherbutton.selected=false
            }
            
        }
        print(rating)
        //updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in priorityButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < rating
        }
    }
}
