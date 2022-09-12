//
//  JCLDetailViewContoller.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.07.2022.
//

import UIKit

protocol JCLDetailViewInput: BaseViewController {}

class JCLDetailViewContoller: BaseViewController {
    
    var router: JCLDetailRouterInput?
    let periods: [JCLDetailPeriod] = [.day, .week, .month, .unlimit]
    
    override var baseModalPresentationStyle: UIModalPresentationStyle { .popover }
    var items: [String] = ["В день", "В неделю", "В месяц", "Безлимит"]
    
    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomConstraint = addEmailButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    private lazy var headerView: BackdropHeaderView = build {
        $0.configure(title: "На интернет-платежи") { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    private let spaceView = UIView()
    private lazy var subtitleLabel: PaddingLabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.medium.withSize(13)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "Введите или выберите лимит"
    }
    
    lazy var limitField: TPAmountFieldView<UUID> = build {
        $0.placeholder = "0 ₸ в месяц"
        $0.keyboardType = .decimalPad
        $0.textField.textAlignment = .left
        $0.backgroundColor = .none
        $0.delegate = self
        $0.addRightClearButton()
        $0.textField.addDoneButtonOnKeyboard()
        $0.id = UUID()
        $0.textField.suffix = "₸ в месяц"
    }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 12
        $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 24 - 32)/3, height: 60)
    }
    
    private lazy var periodStackView: UIStackView = build {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    
    private lazy var addEmailButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Сохранить", for: .normal)
        $0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
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
        view.backgroundColor = BaseColor.base100
        
        for period in periods {
            let button: BaseButton = ButtonFactory().getWhiteButton()
            button.setTitle(period.title, for: .normal)
            button.setTitleColor(BaseColor.base700, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = BaseColor.base700.cgColor
            periodStackView.addArrangedSubview(button)
        }
        
        view.addSubviews(headerView, subtitleLabel, limitField, periodStackView, addEmailButton)
        
        setLayoutConstraints()
        configureKeyboardObserver()
        
        limitField.startEditing()
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 64)
        ]
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            subtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ]
        
        limitField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            limitField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            limitField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            limitField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            limitField.heightAnchor.constraint(equalToConstant: 52)
        ]
        
        periodStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            periodStackView.topAnchor.constraint(equalTo: limitField.bottomAnchor, constant: 16),
            periodStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            periodStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            periodStackView.heightAnchor.constraint(equalToConstant: 36)
        ]
        
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
    
    private func toString(value: String) -> (String, String) {
        return value == "Безлимит" ? ("∞", "Безлимит") : (value, "")
    }
}

extension JCLDetailViewContoller: JCLDetailViewInput { }

extension JCLDetailViewContoller {
    
    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension JCLDetailViewContoller: TPTextFieldViewDelegate {

    func didChange<ID>(text: String, forId id: ID) {
        addEmailButton.setEnabled(text.count > 1)
    }

    func didEndEditing<ID>(text: String, forId id: ID) {
    }

    func didMaskFilled<ID>(text: String, forId id: ID) {
    }
}
