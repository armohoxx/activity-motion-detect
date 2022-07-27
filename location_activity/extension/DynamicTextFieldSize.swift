//
//  DynamicTextFieldSize.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//


import UIKit

class DynamicTextFieldSize {
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        textField.text = text
        textField.font = font
        textField.sizeToFit()
        
        currentHeight = textField.frame.height
        
        return currentHeight
    }
}
