//
//  PasscodeViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.04.2022.
//

import UIKit

protocol PasscodeViewInput: BaseViewController {

    func set(with dotsColors: [UIColor])
    func login()
    func hideBiometryButton()
    func closeSession()
}

class PasscodeViewController: BaseViewController {
    
    var interactor: PasscodeInteractorInput?
    var router: PasscodeRouterInput?
    private var biometryButtonIsHidden = false

    private let subtitleLabel: UILabel = build {
        $0.text = "Привет, Санжар"
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.bold.withSize(28)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private lazy var dotsStackview: UIStackView = {
        var dotView: UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            view.layer.cornerRadius = 8
            view.backgroundColor = BaseColor.base200
            return view
        }
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        for _ in 0..<4 { stack.addArrangedSubview(dotView) }
        return stack
    }()
    private lazy var padCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 40
        layout.itemSize = CGSize(width: 68, height: 68)
        layout.estimatedItemSize = layout.itemSize

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = BaseColor.base50
        collection.isMultipleTouchEnabled = false
        collection.register(TextPadItemCell.self)
        collection.register(BiometryPadItemCell.self)
        collection.register(BackspacePadItemCell.self)
        return collection
    }()
    private lazy var canNotLogInButton: UIButton = build(ButtonFactory().getWhiteButton()) {
        $0.setTitle("Не могу войти", for: .normal)
        $0.addTarget(self, action: #selector(canNotLogInAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        interactor?.authorizeIfRequested()
    }
    
    private func configureSubviews () {
        title = " "
        view.backgroundColor = BaseColor.base50
    
        addSubviews()
        setLayoutConstraints()
        
        padCollectionView.dataSource = self
        padCollectionView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(subtitleLabel)
        view.addSubview(dotsStackview)
        view.addSubview(padCollectionView)
        view.addSubview(canNotLogInButton)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor, constant: 72),
            subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            subtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ]
    
        dotsStackview.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            dotsStackview.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 70),
            dotsStackview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotsStackview.widthAnchor.constraint(equalToConstant: 112),
            dotsStackview.heightAnchor.constraint(equalToConstant: 16)
        ]
        
        canNotLogInButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            canNotLogInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            canNotLogInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        padCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            padCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            padCollectionView.bottomAnchor.constraint(equalTo: canNotLogInButton.topAnchor, constant: -40),
            padCollectionView.widthAnchor.constraint(equalToConstant: 284),
            padCollectionView.heightAnchor.constraint(equalToConstant: 344)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    @objc private func canNotLogInAction() {
        router?.routeToReset(phone: "+7 747 462 62 15")
    }
}

extension PasscodeViewController: PasscodeViewInput {
    
    func hideBiometryButton() {
        biometryButtonIsHidden = true
    }
    
    func set(with dotsColors: [UIColor]) {
        dotsColors.enumerated().forEach { dotsStackview.subviews[$0.offset].backgroundColor = $0.element }
    }

    func login() {
        router?.login()
    }
    
    func closeSession() {
        router?.closeSession()
    }
}

extension PasscodeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 12 }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 9:
            let cell: TextPadItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(text: "Выйти")
            return cell
        case 11:
            if biometryButtonIsHidden || interactor?.isEmptyCode() == false {
                return collectionView.dequeueReusableCell(for: indexPath) as BackspacePadItemCell
            } else {
                let cell: BiometryPadItemCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            }
        default:
            let cell: TextPadItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(text: String((indexPath.item + 1) % 11))
            return cell
        }
    }
}

extension PasscodeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let padItemCell = collectionView.cellForItem(at: indexPath) as? PadItemCellTappable {
            padItemCell.setTapState()
        }

        return true
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let padItemCell = collectionView.cellForItem(at: indexPath) as? PadItemCellTappable {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
                padItemCell.setNormalState()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let padItemCell = collectionView.cellForItem(at: indexPath) as? PadItemCellTappable {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
                padItemCell.setTapState()
            } completion: { _ in
                padItemCell.setNormalState()
            }
        }
        
        interactor?.passItem(at: indexPath.row)
        padCollectionView.reloadData()
    }
}
