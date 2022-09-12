//
//  ChangePhoneNumberViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.04.2022.
//

import UIKit

class ChangePhoneNumberViewContoller: BaseViewController {

    var interactor: ChangePhoneNumberInteractorInput?
    var router: ChangePhoneNumberRouterInput?

    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))

    private lazy var subtitleLabel: PaddingLabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular.withSize(17)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.insets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }

    private let phoneId = UUID()
    lazy var phoneField: TPTextFieldView<UUID> = build {
        $0.placeholder = "+7 707 579 05 15"
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

    private lazy var nextButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Продолжить", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        $0.setEnabled(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureKeyboardObserver()
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

        navigationSubtitleLabel.text = "Изменить номер"
        subtitleLabel.text = "Введите новый номер телефона"
        addToStack(subtitleLabel)
        contentStack.setHorizontalSpace(8)
        addToStack(phoneField)
        
        view.backgroundColor = BaseColor.base50
        view.addSubview(nextButton)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            bottomConstraint,
            subtitleLabel.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor, constant: 8)
        ])

        phoneField.startEditing()
        updateStackSpace(spacing: 16)
    }

    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(false, animated: animated)
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
}

extension ChangePhoneNumberViewContoller: ChangePhoneNumberViewInput {

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
    
    func routeToLoader() {
        router?.routeToLoader()
    }
}

extension ChangePhoneNumberViewContoller {

    @objc private func backButtonAction() {
        router?.popToRoot()
    }

    @objc private func nextButtonAction() {
        guard phoneField.text.count == 16 else {
            showAlertOnTop(withMessage: "Введите номер телефона")
            return
        }

        interactor?.checkingPhoneNumber(phone: phoneField.text)
    }
}

extension ChangePhoneNumberViewContoller: TPTextFieldViewDelegate {

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
