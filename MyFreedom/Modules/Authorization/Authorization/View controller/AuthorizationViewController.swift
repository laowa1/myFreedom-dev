//
//  AuthorizationViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

class AuthorizationViewController: BaseViewController {

    var router: AuthorizationRouter?
    var interactor: AuthorizationInteractor?
    
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    private var acceptTerms = false
    private let phoneId = UUID()
    lazy var phoneField: TPTextFieldView<UUID> = build {
        $0.placeholder = "+7 747 462 62 15"
        $0.keyboardType = .phonePad
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .telephoneNumber
        $0.backgroundColor = .none
        $0.delegate = self
        $0.maskFormat = Constants.phoneMask
        
        lazy var clearButton: UIButton = build() {
            $0.setImage(BaseImage.clear.uiImage, for: .normal)
            $0.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        }
        clearButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        clearButton.setContentHuggingPriority(UILayoutPriority(999), for: .vertical)
        $0.textField.rightView = clearButton
        $0.textField.rightViewMode = .whileEditing
        $0.textField.addDoneButtonOnKeyboard()
        $0.id = phoneId
    }
    
    private lazy var agreementStackView: AgreementStackView = build {
        guard let interactor = interactor else { return }
        $0.set(with: interactor.getAgreementModel())
    }
    
    private lazy var nextButton = build(ButtonFactory().getGreenButton()) {
        $0.isEnabled = false
        $0.setTitle("Продолжить", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews () {
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.black
        navigationSubtitleLabel.text = "Введите ваш номер" + "\n" + "телефона"
        addToStack(phoneField, shouldAddConstraints: true)
        view.backgroundColor = BaseColor.backgroundGray
        view.addSubview(agreementStackView)
        view.addSubview(nextButton)
        
        setLayoutConstraints()
        phoneField.startEditing()
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        agreementStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            agreementStackView.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 24),
            agreementStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            agreementStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ]
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            nextButton.topAnchor.constraint(equalTo: agreementStackView.bottomAnchor, constant: 24),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension AuthorizationViewController: AuthorizationViewInput {

    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        router?.presentDocumentList(module: module)
    }
}

extension AuthorizationViewController {
    
    @objc private func backButtonAction() {
        router?.popToRoot()
    }
    
    @objc private func nextButtonAction() {
        phoneField.textField.removeBorderError()
        
        guard phoneField.text.count == 16 else {
            phoneField.textField.addBorderError()
            phoneField.textField.showError()
            showAlertOnTop(withMessage: "Номер телефона должен состоять из не менее 10 цифр")
            return
        }
    }
    
    @objc private func clearAction () {
        phoneField.textField.text = ""
    }
}

extension AuthorizationViewController: TPTextFieldViewDelegate {
    
    func didBeginEditing<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        switch id {
        default: break
        }
    }
    
    func didEndEditing<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        switch id {
        case phoneId:
            if !text.isEmpty { nextButton.isEnabled = true }
        default: break
        }
    }
}

extension AuthorizationViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(URL) {
            UIApplication.shared.open(URL)
        }
        return false
    }
}
