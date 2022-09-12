//
//  OTPStackViewHyphen.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/13/22.
//

import UIKit

final class OPTStackViewHyphen: UIStackView {

    weak var delegate: OTPProtocol?
    private let hyphenView: UIView = build {
        $0.backgroundColor = BaseColor.base700
    }

    private var isError = false
    private(set) static var digitsCount = 6

    private lazy var digitFields: [CustomTextField] = {
        var digitField: CustomTextField {
            let field = TextFeildFactory().getOtpFeild()
            field.delegate = self
            field.myCustomTextFieldDelegate = self
            field.layer.cornerRadius = 12
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
        spacing = 8.0
        alignment = .center

        configureSubviews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addArrangedSubviews(digitFields)
        insertArrangedSubview(hyphenView, at: arrangedSubviews.count/2)

        digitFields.forEach {
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 44).isActive = true
        }

        hyphenView.translatesAutoresizingMaskIntoConstraints = false
        hyphenView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        hyphenView.widthAnchor.constraint(equalToConstant: 8).isActive = true
    }
}

// MARK: - UITextFieldDelegate
extension OPTStackViewHyphen: UITextFieldDelegate {

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

extension OPTStackViewHyphen: CustomTextFieldDelegate {

    func textFieldDidDelete(textFild: UITextField) {
        guard textFild.text?.isEmpty == true else { return }

        if let index = digitFields.firstIndex(where: { $0 == textFild }) {
            let field = digitFields[safe: index - 1]
            field?.becomeFirstResponder()
        }
    }
}


