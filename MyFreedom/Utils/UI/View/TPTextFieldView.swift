//
//  TextFieldView.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit
import InputMask

protocol TPTextFieldViewDelegate: TextFieldDelegate {
    func didMaskFilled<ID>(text: String, forId id: ID)
    func didPressAuxilaryButton<ID>(forId id: ID)
    func didSelectView<ID>(at id: ID)
}

extension TPTextFieldViewDelegate {
    func didMaskFilled<ID>(text: String, forId id: ID) {}
    func didPressAuxilaryButton<ID>(forId id: ID) {}
    func didSelectView<ID>(at id: ID) {}
}

class TPTextFieldView<ID: Equatable>: UIView, MaskedTextFieldDelegateListener {

    let stackView = UIStackView()
    let textField = SuffixTextField()
    @objc var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 16) }
    private let auxilaryButton = UIButton()
    private lazy var textViewHeightConstraint = textField.heightAnchor.constraint(equalToConstant: 58)

    var id: ID?
    weak var delegate: TPTextFieldViewDelegate?

    private var isEditing = false
    var placeholderColor: UIColor { BaseColor.base500 }

    private var maskConfiguration = CustomMaskedTextFieldDelegate(autocompleteOnFocus: true)
    private var extractedValue = ""
    
    var isEditable: Bool {
        get { textField.isUserInteractionEnabled }
        set { textField.isUserInteractionEnabled = newValue }
    }

    var text: String {
        get { textField.text ?? "" }
        set {
            if newValue.isEmpty {
                textField.text = newValue
            } else {
                if maskFormat != nil {
                    maskConfiguration.put(text: newValue, into: textField)
                } else {
                    textField.text = newValue
                }
            }
        }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var placeholder = "" {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
    }

    var maskFormat: String? {
        didSet {
            if let mask = maskFormat {
                maskConfiguration.primaryMaskFormat = mask
                textField.delegate = maskConfiguration
            } else {
                textField.delegate = self
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
        configureSubviews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configureSubviews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func addSubviews() {
        addSubview(stackView)
        addSubview(auxilaryButton)

        stackView.addArrangedSubviews(textField)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        textField.rightViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        textField.tintColor = BaseColor.green500
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self)

        auxilaryButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            auxilaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            auxilaryButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            auxilaryButton.heightAnchor.constraint(equalToConstant: 24),
            auxilaryButton.widthAnchor.constraint(equalToConstant: 24)
        ]
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textViewHeightConstraint.priority = .defaultHigh
        layoutConstraints += [textViewHeightConstraint]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill

        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true

        textField.isUserInteractionEnabled = true
        textField.font = BaseFont.regular.withSize(18)
        textField.tintColor = BaseColor.green500
        textField.textColor = BaseColor.base900
        textField.keyboardType = .default
        if #available(iOS 11.0, *) {
            textField.smartQuotesType = .no
        }
        textField.backgroundColor = BaseColor.base200
        textField.autocorrectionType = .no
        textField.returnKeyType = .default
        textField.autocapitalizationType = .none
        auxilaryButton.isHidden = true
        maskConfiguration.affinityCalculationStrategy = .prefix
    }

    private func setActions() {
        textField.delegate = self
        maskConfiguration.listener = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        addGestureRecognizer(tapGestureRecognizer)
        auxilaryButton.addTarget(self, action: #selector(auxilaryButtonPress), for: .touchUpInside)

        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func auxilaryButtonPress() {
        textField.resignFirstResponder()
        if let delegate = delegate, let id = id {
            delegate.didPressAuxilaryButton(forId: id)
        }
    }

    @objc func startEditing() {
        if isEditable {
            textField.becomeFirstResponder()
        } else {
            if let delegate = delegate, let id = id {
                delegate.didSelectView(at: id)
            }
        }
    }

    @objc private func clearAction(){
        textField.text = ""
        auxilaryButtonPress()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let delegate = delegate, let id = id {
            delegate.didChange(text: textField.text ?? "", forId: id)
            delegate.validate(text: textField.text ?? "", forId: id)

            if textField.textColor != BaseColor.base900 {
                removeError()
            }
        }
    }

    func set(auxilaryButtonImage: UIImage?) {
        auxilaryButton.tintColor = .black
        auxilaryButton.setImage(auxilaryButtonImage, for: .normal)
        auxilaryButton.isHidden = auxilaryButtonImage == nil
        
        textField.rightView?.frame = CGRect(x: 0, y: 0, width: 16+24, height: self.frame.height)
        textField.layoutIfNeeded()
    }
    
    func error(needShake: Bool = false) {
        textField.textColor = BaseColor.red700
        textField.addBorderError()
        if needShake {
            textField.showError()
        }
    }
    
    func removeError() {
        textField.removeBorder()
        textField.textColor = BaseColor.base900
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let delegate = delegate, let id = id {
            return delegate.shouldBeginEditing(text: textField.text ?? "", forId: id)
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let delegate = delegate, let id = id {
            delegate.didBeginEditing(text: textField.text ?? "", forId: id)
        }
        
        removeError()
        textField.addBorderFocus()
        isEditing = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditing = false
        textField.removeBorder()
        if extractedValue.isEmpty && maskFormat != nil {
            textField.text = extractedValue
        } else {
            if let delegate = delegate, let id = id {
                delegate.didEndEditing(text: textField.text ?? "", forId: id)
            }
        }
    }

    func set(height: CGFloat) {
        textViewHeightConstraint.constant = height
        textField.layoutIfNeeded()
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if text == "\n" {
            defer { endEditing(true) }
            return false
        }

        let updatedText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: text)

        if let delegate = delegate, let id = id {
            return delegate.allowCharacters(in: updatedText, forId: id)
        }

        return true
    }

    func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        extractedValue = value
        guard isEditing else { return }
        
        if complete && maskFormat != nil {
            if let delegate = delegate, let id = id {
                delegate.didMaskFilled(text: textField.text ?? "", forId: id)
            }
        } else {
            textFieldDidChange(textField)
        }
    }

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.endEditing(true)
        return true
    }

    @objc func clean() {
        textField.attributedText = nil
        id = nil
        delegate = nil
        maskFormat = nil
        text = ""
        isEditable = true
        keyboardType = .default
        autocapitalizationType = .none
        placeholder = ""
        textField.rightView = nil
        stackView.spacing = 0
        auxilaryButton.setImage(nil, for: .normal)
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
    }
}

extension TPTextFieldView: CleanableView { }

extension TPTextFieldView {

    func addRightClearButton() {
        lazy var clearButton: UIButton = build() {
            $0.setImage(BaseImage.clear.uiImage, for: .normal)
            $0.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        }
        clearButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        clearButton.setContentHuggingPriority(UILayoutPriority(999), for: .vertical)
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
    }
}
