//
//  EmailChangeViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/12/22.
//

import UIKit

class AddEmailViewController: BaseViewController {

    var router: AddEmailRouterInput?
    var interactor: AddEmailInteractorInput?

    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomConstraint = addEmailButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    private let spaceView = UIView()
    private lazy var subtitleLabel: PaddingLabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular.withSize(16)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.insets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }

    private let emailId = UUID()
    lazy var emailField: TPTextFieldView<UUID> = build {
        $0.placeholder = "Введите Ваш email"
        $0.keyboardType = .emailAddress
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .emailAddress
        $0.backgroundColor = .none
        $0.delegate = self
        $0.addRightClearButton()
        $0.textField.addDoneButtonOnKeyboard()
        $0.id = emailId
    }

    private lazy var addEmailButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Добавить email", for: .normal)
        $0.addTarget(self, action: #selector(addEmailAction), for: .touchUpInside)
        $0.setEnabled(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        title = " "
        navigationSubtitleLabel.text = "Добавить email"
        subtitleLabel.text = "Мы пришлем Вам письмо по email для подтверждения"

        updateStackSpace(spacing: 40)
        addToStack(subtitleLabel, shouldAddConstraints: true)
        addToStack(emailField)
        view.addSubview(addEmailButton)
        
        setLayoutConstraints()
        configureKeyboardObserver()
        
        emailField.startEditing()
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        addEmailButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            addEmailButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            addEmailButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            addEmailButton.heightAnchor.constraint(equalToConstant: 52),
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
}

extension AddEmailViewController: AddEmailViewInput { }

extension AddEmailViewController {
    
    @objc private func backButtonAction() {
        router?.routeToBack()
    }

    @objc private func addEmailAction() {
        router?.routeToEmailVerification()
    }
}

extension AddEmailViewController: TPTextFieldViewDelegate {

    func didChange<ID>(text: String, forId id: ID) {
        addEmailButton.setEnabled(text.count > 1)
    }

    func didEndEditing<ID>(text: String, forId id: ID) {
    }

    func didMaskFilled<ID>(text: String, forId id: ID) {
    }
}

extension AddEmailViewController: VerificationParentRouter {
    
    func confirm(id: UUID) { }

    func fail(id: UUID) { }

    func resend(id: UUID) { }
}

