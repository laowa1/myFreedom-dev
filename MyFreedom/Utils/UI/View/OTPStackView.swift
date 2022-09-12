//
//  OTPStackView.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.03.2022.
//

import UIKit

protocol OTPProtocol: AnyObject {
    func didChange(code: String)
}

final class OTPStackView: UIStackView {
    
    weak var delegate: OTPProtocol?
    
    private var isError = false
    private(set) static var digitsCount = 4

    private lazy var digitFields: [CustomTextField] = {
        var digitField: CustomTextField {
            let field = TextFeildFactory().getOtpFeild()
            field.delegate = self
            field.myCustomTextFieldDelegate = self
            field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//            field.textContentType = .oneTimeCode
            field.text = ""
            return field
        }

        var digitFields = [CustomTextField]()
        for _ in 0..<Self.digitsCount {
            digitFields.append(digitField)
        }
        return digitFields
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 10.0
        alignment = .fill
        distribution = .fillEqually
        digitFields.forEach {
            $0.heightAnchor.constraint(equalToConstant: 58).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 58).isActive = true
        }
        addArrangedSubviews(digitFields)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextFieldDelegate
extension OTPStackView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            textField.text = string
            if let index = digitFields.firstIndex(where: { $0 == textField })  {
                digitFields[safe: index+1]?.becomeFirstResponder()
            }
            
            let code = digitFields.map({ $0.text }).nonNilJoined()
            delegate?.didChange(code: code)
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard !isError else { return }
        textField.removeBorder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard !isError else { return }
        textField.addBorderFocus()
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField){
        removeBorder()
        let text = textField.text
        if text?.count == 1 {
            if let index = digitFields.firstIndex(where: { $0 == textField }) {
                let field = digitFields[safe: index + 1]
                field?.becomeFirstResponder()
            }
        }

        if text?.count == 0 || text == nil {
            if let index = digitFields.firstIndex(where: { $0 == textField }) {
                let field = digitFields[safe: index - 1]
                field?.becomeFirstResponder()
            }
        }
    }

    func cleanCodeText(withBorder: Bool = true) {
        digitFields.forEach {
            if withBorder { $0.removeBorder() }
            $0.text = nil
        }
        let feild = digitFields.first
        feild?.becomeFirstResponder()
    }
    
    func error() {
        isError = true
        digitFields.forEach {
            $0.text = nil
            $0.addBorderError()
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.showError()
        }
        digitFields.first?.becomeFirstResponder()
    }
    
    func removeBorder() {
        guard isError else { return }
        digitFields.forEach { $0.removeBorder() }
        isError = false
    }
}

extension OTPStackView: CustomTextFieldDelegate {

    func textFieldDidDelete(textFild: UITextField) {
        guard textFild.text?.isEmpty == true else { return }

        if let index = digitFields.firstIndex(where: { $0 == textFild }) {
            let field = digitFields[safe: index - 1]
            field?.becomeFirstResponder()
        }
    }
}
