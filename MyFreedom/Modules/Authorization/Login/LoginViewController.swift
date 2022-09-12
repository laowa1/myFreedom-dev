//
//  LoginViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 04.03.2022.
//

import UIKit

protocol LoginViewInput: BaseViewInput {

    func routeToVerification(phone: String)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToChangingPhoneNumber(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID)
}

class LoginViewController: BaseViewController {
    
    var interactor: LoginInteractorInput?
    var router: LoginRouterInput?
    
    private let passwordId = UUID()
    lazy var phoneField: TPTextFieldView<UUID> = build {
        $0.text = "+7 747 462 62 15"
        $0.keyboardType = .phonePad
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .telephoneNumber
        $0.backgroundColor = .none
        $0.delegate = self
        $0.maskFormat = Constants.phoneMask
        $0.textField.textColor = BaseColor.base900
        $0.id = UUID()
        $0.isEditable = false
    }
    
    private lazy var forgotButton = build(ButtonFactory().getTextButton()){
        $0.setTitle("Забыли пароль?", for: .normal)
        $0.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
    }
    
    private lazy var passwordField: TPTextFieldView<UUID> = build {
        $0.placeholder = "Ваш пароль"
        $0.keyboardType = .asciiCapable
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .password
        $0.backgroundColor = .none
        $0.delegate = self
        $0.id = passwordId
        $0.textField.isSecureTextEntry = true
        $0.textField.rightView = forgotButton
        $0.textField.rightViewMode = .always
        $0.textField.addDoneButtonOnKeyboard()
    }
    
    private lazy var nextButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Продолжить", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    private lazy var changePhoneButton: UIButton = build(ButtonFactory().getWhiteButton()) {
        $0.setTitle("Изменился номер телефона", for: .normal)
        $0.addTarget(self, action: #selector(changePhoneAction), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureSubviews () {
        navigationSubtitleLabel.text = "Войти с помощью" + "\n" + "логина и пароля"
        let subviews: [UIView] = [phoneField, passwordField]
        subviews.forEach {
            addToStack($0, shouldAddConstraints: true)
        }
        view.backgroundColor = BaseColor.base50
        view.addSubview(nextButton)
        view.addSubview(changePhoneButton)
        setLayoutConstraints()
        
        passwordField.startEditing()
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            nextButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ]
        
        changePhoneButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            changePhoneButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 24),
            changePhoneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            changePhoneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            changePhoneButton.heightAnchor.constraint(equalToConstant: 28)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    @objc private func nextButtonAction() {
        passwordField.textField.removeBorder()
        if passwordField.text.count < 6 {
            passwordField.error()
            showAlertOnTop(withMessage: "Пароль должен состоять из не менее 6 символов")
            return
        }
        
        router?.routeToComeUpCode()
    }
    
    @objc private func changePhoneAction() {
        interactor?.changePhone()
    }
    
    @objc private func forgotPasswordAction () {
        router?.routeToPasswordRecovery(phone: phoneField.text)
    }
}

extension LoginViewController: TPTextFieldViewDelegate {
    
    func didBeginEditing<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        switch id {
        default: break
        }
    }
    
    func didEndEditing<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        switch id {
        default: break
        }
    }
}

extension LoginViewController: LoginViewInput {

    func routeToVerification(phone: String) {
        router?.routeToVerification(phone: phone)
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        router?.routeToInformConfirmIdentity(model: model, delegate: delegate)
    }
    
    func routeToChangingPhoneNumber(delegate: SIVConfirmButtonDelegate, id: UUID) {
        router?.routeToChangingPhoneNumber(delegate: delegate, id: id)
    }
    
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID) {
        router?.routeToEnterIIN(delegate: delegate, id: id)
    }
}
