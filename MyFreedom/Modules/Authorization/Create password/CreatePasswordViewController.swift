//
//  CreatePasswordViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 15.03.2022.
//

import UIKit

protocol CreatePasswordViewInput: BaseViewInput { }

final class CreatePasswordViewController: BaseViewController {
    
    var interactor: CreatePasswordInteractorInput?
    var router: CreatePasswordRouterInput?
    
    private let newPasswordId = UUID()
    private let confirmPasswordId = UUID()
    private var currentTextFieldId: UUID?
    
    private var hideShowButton: UIButton {
        let button = ButtonFactory().getTextButton()
        button.setTitle("Показать", for: .normal)
        button.setTitle("Скрыть", for: .selected)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        return button
    }
    
    private lazy var newPasswordField: TPTextFieldView<UUID> = build {
        $0.keyboardType = .asciiCapable
        $0.textField.addDoneButtonOnKeyboard()
        
        $0.placeholder = "Введите пароль"
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .newPassword
        $0.textField.isSecureTextEntry = true
        
        $0.textField.rightView = hideShowButton
        $0.textField.rightViewMode = .whileEditing
        
        $0.id = newPasswordId
        $0.delegate = self
        $0.backgroundColor = .clear
    }
    private lazy var confirmPasswordField: TPTextFieldView<UUID> = build {
        $0.keyboardType = .asciiCapable
        $0.textField.addDoneButtonOnKeyboard()
        
        $0.placeholder = "Повторите пароль"
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .password
        $0.textField.isSecureTextEntry = true
        
        $0.textField.rightView = hideShowButton
        $0.textField.rightViewMode = .whileEditing
        
        $0.id = confirmPasswordId
        $0.delegate = self
        $0.backgroundColor = .clear
    }
    private let hintStack = HintStackView()
    private lazy var confirmButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Продолжить", for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    deinit {
        print("CreatePasswordViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSubtitleLabel.text = "Придумайте пароль"
        
        addSubviews()
        setLayoutConstraints()
        setupToolBar()
        
        setHint(isError: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func addSubviews() {
        addToStack(newPasswordField)
        addToStack(confirmPasswordField)
        addToStack(hintStack)
        view.addSubview(confirmButton)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            confirmButton.topAnchor.constraint(equalTo: hintStack.bottomAnchor, constant: 24),
            confirmButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            confirmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 52)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let prevItemButton = UIBarButtonItem(image: UIView.keyboardUpImage() , style: .plain , target: self, action: #selector(switchToThePrevTextfield))
        let nextItemButton = UIBarButtonItem(image: UIView.keyboardDownImage() , style: .plain , target: self, action: #selector(switchToTheNextTextfield))

        toolBar.setItems([prevItemButton, nextItemButton], animated: false)

        newPasswordField.textField.inputAccessoryView = UIView()
        confirmPasswordField.textField.inputAccessoryView = UIView()

        newPasswordField.textField.inputAccessoryView = toolBar
        confirmPasswordField.textField.inputAccessoryView = toolBar
        
        newPasswordField.startEditing()
    }
    
    private func isValidNewPassword() -> Bool {
        guard !newPasswordField.text.isEmpty,
              newPasswordField.text.count >= 8
        else { return false }
        return true
    }
    
    private func isValidConfirmPassword() -> Bool {
        guard isValidNewPassword(),
              newPasswordField.text == confirmPasswordField.text
        else { return false }
        
        return true
    }
    
    private func setHint(isError: Bool, text: String? = nil) {
        let model: HintSVModel
        let hintText = text != nil ? text! : "Пароль должен состоять из минимум 6-ти символов и содержать латинские буквы, цифры и спецзнаки (перечисление)"
        model = HintSVModel(icon: .hintError, text: hintText, isError: isError)
        hintStack.set(with: model)
    }
    
    private func removeBorderError() {
        newPasswordField.textField.removeBorder()
        newPasswordField.textField.textColor = .black
        confirmPasswordField.textField.removeBorder()
        confirmPasswordField.textField.textColor = .black
    }
}

extension CreatePasswordViewController: CreatePasswordViewInput { }

extension CreatePasswordViewController {

    @objc private func showPassword(_ sender: UIButton) {
        guard let textField = sender.superview as? UITextField else { return }
        
        textField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    
    @objc func switchToTheNextTextfield() {
        switch currentTextFieldId {
        case newPasswordId:
            confirmPasswordField.startEditing()
        default:
            view.endEditing(true)
        }
    }
    
    @objc func switchToThePrevTextfield() {
        switch self.currentTextFieldId {
        case confirmPasswordId:
            newPasswordField.startEditing()
        default:
            view.endEditing(true)
        }
    }
    
    @objc func confirmButtonTapped() {
        router?.routeToComeUpCode()
    }
}

extension CreatePasswordViewController: TPTextFieldViewDelegate {
    
    func didBeginEditing<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        
        switch id {
        case newPasswordId:
            currentTextFieldId = newPasswordId
            newPasswordField.textField.removeBorder()
            newPasswordField.textField.textColor = .black
        case confirmPasswordId:
            currentTextFieldId = confirmPasswordId
            confirmPasswordField.textField.removeBorder()
            confirmPasswordField.textField.textColor = .black
        default:
            break
        }
    }
    
    func didEndEditing<ID>(text: String, forId id: ID) {
        let isValid = isValidNewPassword() && isValidConfirmPassword()
        let isEmpty = newPasswordField.text.isEmpty && confirmPasswordField.text.isEmpty
        if isValid || isEmpty {
            removeBorderError()
            setHint(isError: false)
        }
        
        if !isValidNewPassword() {
            newPasswordField.textField.addBorderError()
            newPasswordField.textField.textColor = BaseColor.red700
            setHint(isError: true)
        }
        
        if !isValidConfirmPassword() && !confirmPasswordField.text.isEmpty {
            confirmPasswordField.textField.addBorderError()
            confirmPasswordField.textField.textColor = BaseColor.red700
            setHint(isError: true, text: "Пароли не совпадают")
        } else if !isValidConfirmPassword() && confirmPasswordField.text.isEmpty {
            removeBorderError()
            setHint(isError: false)
        }
        
        confirmButton.isEnabled = isValidNewPassword() && isValidConfirmPassword()
    }
}
