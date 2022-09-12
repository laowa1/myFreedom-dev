//
//  LimitDetailViewContoller.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import UIKit

protocol LimitDetailViewInput: BaseViewController { }

class LimitDetailViewContoller: BaseViewController {

    var router: LimitDetailRouterInput?
//    var interactor: AddEmailInteractorInput?
    
    override var baseModalPresentationStyle: UIModalPresentationStyle { .popover }
    var items: [Decimal] = [50_000, 100_000, 250_000, 500_000, 1_000_000, -1]

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

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(BaseCollectionContainerCell<LimitDetailItemView>.self)
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
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
        view.addSubviews(headerView, subtitleLabel, limitField, collectionView, addEmailButton)
        
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
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: limitField.bottomAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 144)
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
    
    private func toString(value: Decimal) -> (String, String) {
        if value == -1 {
            return ("∞", "Безлимит")
        } else if value >= 1_000_000 {
            return ((value/1_000_000).description, "млн ₸")
        } else if value >= 1_000 {
            return ((value/1_000).description, "тысяч ₸")
        } else {
            return ("", "")
        }
    }
}

extension LimitDetailViewContoller: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionContainerCell<LimitDetailItemView> = collectionView.dequeueReusableCell(for: indexPath)
        let item = items[safe: indexPath.row] ?? 0
        let titles = toString(value: item)
        cell.innerView.titleLabel.text = titles.0
        cell.innerView.subtitleLabel.text = titles.1
        cell.addCorner(radius: 16)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var text = items[indexPath.row].description
        if text == "-1" {
            text = "∞"
        }
        limitField.set(text: text)
        limitField.textField.setNeedsDisplay()
        addEmailButton.setEnabled(limitField.text.count > 1)
    }
}

extension LimitDetailViewContoller: LimitDetailViewInput { }

extension LimitDetailViewContoller {
    
    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension LimitDetailViewContoller: TPTextFieldViewDelegate {

    func didChange<ID>(text: String, forId id: ID) {
        addEmailButton.setEnabled(text.count > 1)
    }

    func didEndEditing<ID>(text: String, forId id: ID) {
    }

    func didMaskFilled<ID>(text: String, forId id: ID) {
    }
}
