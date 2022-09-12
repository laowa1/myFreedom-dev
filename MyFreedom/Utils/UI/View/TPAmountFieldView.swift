//
//  TPAmountFieldView.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import UIKit

class TPAmountFieldView<T: Equatable>: TPTextFieldView<T> {
    
    private var textFormatter: AmountFormatter { AmountFormatter(useCommaSeparator: false, attributes: attributes) }
    private let textValidator = TPAmountTextValidator()
    private var attributes: [NSAttributedString.Key: Any] {
        return [
            .font: BaseFont.medium,
            .foregroundColor: BaseColor.base900
        ]
    }
    
    func set(text: String) {
        textField.attributedText = textFormatter.apply(to: text)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            defer { endEditing(true) }
            return false
        }
        let text = textField.text ?? ""
        var updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if text == "0" && string != "," && string != "." {
            updatedText = string
        }

        // Replacing , to .
        if string.contains(",") {
            updatedText = updatedText.replacingOccurrences(of: ",", with: ".")
        }
        
        if textValidator.validateCharacters(in: updatedText) {
            set(text: updatedText)
            textField.setNeedsDisplay()

            if let delegate = delegate, let id = id {
                delegate.didChange(text: updatedText, forId: id)
            }
        }

        return false
    }
}
