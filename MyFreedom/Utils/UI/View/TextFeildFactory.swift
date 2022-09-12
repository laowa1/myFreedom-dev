//
//  TextFeildFactory.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.03.2022.
//

import UIKit

protocol CustomTextFeildFactoryProtocol {
    func getOtpFeild() -> CustomTextField
}

class TextFeildFactory: CustomTextFeildFactoryProtocol {
    
    func getOtpFeild() -> CustomTextField {
        let field = CustomTextField()
        field.leftView = .none
        field.font = BaseFont.semibold.withSize(22)
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.backgroundColor = BaseColor.base200
        field.clipsToBounds = true
        field.layer.cornerRadius = 16
        field.tintColor = BaseColor.green500
        field.textColor = BaseColor.base900
        return field
    }
}


protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidDelete(textFild: UITextField)
}

class CustomTextField: UITextField {

    weak var myCustomTextFieldDelegate: CustomTextFieldDelegate?

    override var canBecomeFocused: Bool { true }

    override func deleteBackward() {
        super.deleteBackward()
        myCustomTextFieldDelegate?.textFieldDidDelete(textFild: self)
    }
}
