//
//  UITextField+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }

    func removeBorder() {
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }

    func addBorderError() {
        layer.borderWidth = 1
        layer.borderColor = BaseColor.red700.cgColor
    }

    func addBorderFocus() {
        layer.borderWidth = 1
        layer.borderColor = BaseColor.green500.cgColor
    }
}
