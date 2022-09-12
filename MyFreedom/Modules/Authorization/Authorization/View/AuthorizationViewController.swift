//
//  AuthorizationViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

class AuthorizationViewController: BaseViewController {

    var router: AuthorizationRouterInput?
    var interactor: AuthorizationInteractorInput?
    
    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        $0.addRightClearButton()
        $0.textField.addDoneButtonOnKeyboard()
        $0.id = phoneId
    }
    
    private lazy var agreementStackView: AgreementStackView = build {
        guard let interactor = interactor else { return }
        $0.set(with: interactor.getAgreementModel())
    }
    
    private lazy var nextButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Продолжить", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        $0.setEnabled(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.validatePhone()
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver.startListening()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardObserver.stopListening()
    }

    private func configureSubviews() {
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        navigationSubtitleLabel.text = "Введите ваш номер" + "\n" + "телефона"
        addToStack(phoneField, shouldAddConstraints: true)
        view.backgroundColor = BaseColor.base50
        view.addSubview(agreementStackView)
        view.addSubview(nextButton)
        
        setLayoutConstraints()
        phoneField.startEditing()
        updateStackSpace(spacing: 24)
        interactor?.testLog()
        configureKeyboardObserver()
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
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            bottomConstraint
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func configureKeyboardObserver() {
        keyboardObserver.keyboardStateHandler = { [weak self] params in
            guard let self = self else { return }
            switch params.state {
            case .willShow:
                self.bottomConstraint.constant = -abs(params.rect.height - 12)
                self.view.layoutIfNeeded()
            case .willHide:
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(interactor?.isHiddenBackButton() == true, animated: animated)
    }
}

extension AuthorizationViewController: AuthorizationViewInput {

    func agreement(isSelected: Bool) {
        nextButton.setEnabled(isSelected)
    }

    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        router?.presentDocumentList(module: module)
    }

    func routeToVerification(phone: String, id: UUID) {
        router?.routeToVerification(phone: phone, id: id)
    }

    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID) {
        router?.routeToEnterIIN(delegate: delegate, id: id)
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        router?.routeToInformConfirmIdentity(model: model, delegate: delegate)
    }

    func routeToComeUpCode() {
        router?.routeToComeUpCode()
    }
    
    func routeToWebview(title: String, url: URL) {
        router?.routeToWebview(title: title, url: url)
    }
    
    func routeToLoader() {
        router?.routeToLoader()
    }
}

extension AuthorizationViewController {
    
    @objc private func backButtonAction() {
        router?.popToRoot()
    }
    
    @objc private func nextButtonAction() {
        guard phoneField.text.count == 16 else {
            view.notificationError()
            showAlertOnTop(withMessage: "Введите номер телефона")
            return
        }

        guard interactor?.agreementSelected == true else {
            view.notificationError()
            nextButton.setEnabled(false)
            showAlertOnTop(withMessage: "Необходимо принять условия Банка")
            return
        }

        interactor?.checkingPhoneNumber(phone: phoneField.text)
    }
}

extension AuthorizationViewController: TPTextFieldViewDelegate {

    func didChange<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        switch id {
        case phoneId:
            nextButton.setEnabled(text.count > 15)
        default: break
        }
    }

    func didMaskFilled<ID>(text: String, forId id: ID) {
        guard let id = id as? UUID else { return }
        switch id {
        case phoneId:
            nextButton.setEnabled(text.count > 15)
        default: break
        }
    }
}
