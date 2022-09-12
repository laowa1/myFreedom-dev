//
//  CustomMaskedTextFieldDelegate.swift
//  MyFreedom
//
//  Created by m1pro on 15.06.2022.
//

import InputMask

class CustomMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    
    override func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        var text = string
        if string.count >= 10 && textField.keyboardType == .phonePad {
            text = String(text.suffix(10))
            put(text: "7\(text)", into: textField)
            return false
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: text)
    }
}
