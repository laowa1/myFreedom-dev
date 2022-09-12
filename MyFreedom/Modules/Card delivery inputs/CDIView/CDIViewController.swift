//
//  CDIViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 28.06.2022.
//

import UIKit

class CDIViewController: BaseViewController {
    
    var router: CDIRouterInput?
    var interactor: CDIInteractorInput?
    var model: CurrentInputLevelModel?
    let currentLevel: Int
    let maxLevel: Int
    
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    
    private lazy var inputTextField: TPTextFieldView<UUID> = build {
        $0.delegate = self
        $0.placeholder = model?.placeHolder ?? ""
        $0.keyboardType = model?.keyboardType ?? .default
        $0.id = UUID()
        $0.textField.text = model?.value
    }
    
    private lazy var currentLevelView = InputLevelView()
    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomConstraint = currentLevelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    init(currentLevel: Int, maxLevel: Int) {
        self.currentLevel = currentLevel
        self.maxLevel = maxLevel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = model?.title ?? ""
        view.addSubviews(inputTextField, currentLevelView)
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        setLayoutConstraints()
        configureKeyboardObserver()
        currentLevelView.configure(currentLevel: currentLevel, maxLevel: maxLevel, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver.startListening()
        inputTextField.startEditing()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardObserver.stopListening()
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints: [NSLayoutConstraint] = []
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ]
        
        currentLevelView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            currentLevelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentLevelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentLevelView.heightAnchor.constraint(equalToConstant: 68),
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
        animated: Bool) {
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func backButtonAction() {
        router?.routeToParent()
    }
}

extension CDIViewController: CDIViewInput {}

extension CDIViewController: TPTextFieldViewDelegate {
    func didChange<ID>(text: String, forId id: ID) {
        model?.value = text
    }
}

extension CDIViewController: InputLevelDelegate {
    
    func onBackButtonClicked() {
        router?.routeToPrevius()
    }
    
    func onNextButtonClicked() {
        router?.routeToNext()
    }
}
