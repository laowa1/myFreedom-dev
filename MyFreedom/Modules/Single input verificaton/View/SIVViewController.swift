//
//  SIVViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 16.03.2022.
//

import UIKit

final class SIVViewController<T: SIVInteractorInput>: BaseViewController {
    
    var router: SIVRouterInput?
    var interactor: T?
    var delegate: SIVConfirmButtonDelegate?

    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    private lazy var inputField: TPTextFieldView<UUID> = build {
        $0.placeholder = interactor?.placeholder ?? ""
        $0.keyboardType = interactor?.keyboardType ?? .phonePad
        $0.textField.textContentType = interactor?.textContentType
        $0.delegate = self
        $0.maskFormat = interactor?.inputFieldMask
        $0.id = UUID()
        $0.textField.returnKeyType = .continue
        $0.textField.tintColor = BaseColor.green500
    }
    private var spaceView = UIView()
    private lazy var errorLabel: PaddingLabel = build {
        $0.textColor = BaseColor.red700
        $0.font = BaseFont.regular.withSize(13)
        $0.isHidden = true
    }
    private lazy var confirmButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Продолжить", for: .normal)
        $0.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
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
        title = " "
        navigationItem.leftBarButtonItem = goBackButton
        navigationSubtitleLabel.text = interactor?.title

        updateStackSpace(spacing: 8)
        addToStack(inputField, shouldAddConstraints: true)
        addToStack(errorLabel)
        addToStack(spaceView)
        view.addSubview(confirmButton)
    
        setLayoutConstraints()
        configureKeyboardObserver()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.56) {
            self.inputField.startEditing()
        }
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            confirmButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            confirmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
            bottomConstraint
        ]

        spaceView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [spaceView.heightAnchor.constraint(equalToConstant: 8)]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func checkError(text: String) {
        guard let interactor = interactor,
              interactor.validate(text: text)
        else {
            if text.isEmpty {
                resetError()
                return
            }

            inputField.error()
            set(error: interactor?.errorText ?? "")
            confirmButton.setEnabled(false)

            return
        }

        confirmButton.setEnabled(interactor.validate(text: text))
    }
    
    private func set(error message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func resetError() {
        errorLabel.isHidden = true
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
    
    @objc func confirmButtonAction() {
        guard let interactor = interactor,
              let id = interactor.id,
              interactor.validate(text: inputField.text) else { return }
        delegate?.confirmButtonAction(text: inputField.text, id: id)
    }

    @objc private func backButtonAction() {
        router?.popToRoot()
    }
}

extension SIVViewController: TPTextFieldViewDelegate {
    
    func didChange<ID>(text: String, forId id: ID) {
        resetError()
        confirmButton.setEnabled(interactor?.validate(text: text) ?? false)
    }
    
    func didEndEditing<ID>(text: String, forId id: ID) {
        checkError(text: text)
    }
        
    func didMaskFilled<ID>(text: String, forId id: ID) {
        checkError(text: text)
    }
}

extension SIVViewController: SIVViewInput {}
