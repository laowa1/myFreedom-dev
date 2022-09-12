//
//  CUAccessCodeViewContoller.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 17.03.2022.
//

import UIKit

class CUAccessCodeViewContoller: BaseViewController {
    
    var interactor: CUAccessCodeInteractorInput?
    var router: CUAccessCodeRouterInput?

    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    private let subtitleLabel: UILabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    private lazy var topView = UIView()
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
        collection.register(BackspacePadItemCell.self)
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        title = " "
        navigationItem.leftBarButtonItem = goBackButton
        navigationSubtitleLabel.text = interactor?.getType().title
        subtitleLabel.text = interactor?.getType().subtitle
        view.backgroundColor = BaseColor.base50
    
        addSubviews()
        setLayoutConstraints()

        padCollectionView.dataSource = self
        padCollectionView.delegate = self

        if let type = interactor?.getType(), (type == .repeat || type == .repeatNew) {
            navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    private func addSubviews() {
        view.addSubview(subtitleLabel)
        view.addSubview(topView)
        topView.addSubview(dotsStackview)
        view.addSubview(padCollectionView)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            subtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ]
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            topView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            topView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topView.bottomAnchor.constraint(equalTo: padCollectionView.topAnchor)
        ]
        
        dotsStackview.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            dotsStackview.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            dotsStackview.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            dotsStackview.widthAnchor.constraint(equalToConstant: 112),
            dotsStackview.heightAnchor.constraint(equalToConstant: 16)
        ]

        padCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            padCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            padCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56),
            padCollectionView.widthAnchor.constraint(equalToConstant: 284),
            padCollectionView.heightAnchor.constraint(equalToConstant: 344)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension CUAccessCodeViewContoller: CUAccessCodeViewInput {

    func set(with dotsColors: [UIColor]) {
        dotsColors.enumerated().forEach { dotsStackview.subviews[$0.offset].backgroundColor = $0.element }
    }

    func routeToRepeat(code: String, popToRoot: Bool, type: CUAccessCodeType) {
        router?.routeToRepeat(code: code, popToRoot: popToRoot, type: type)
    }

    func routeToInform(deledate: InformPUButtonDelegate, model: InformPUViewModel) {
        router?.routeToInform(deledate: deledate, model: model)
    }

    func login() {
        router?.login()
    }
    
    func closeSession() {
        router?.closeSession()
    }
}

extension CUAccessCodeViewContoller: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 12 }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 9:
            let cell: TextPadItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.contentView.layer.opacity = 0
            return cell
        case 11:
            return collectionView.dequeueReusableCell(for: indexPath) as BackspacePadItemCell
        default:
            let cell: TextPadItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(text: String((indexPath.item + 1) % 11))
            return cell
        }
    }
}

extension CUAccessCodeViewContoller: UICollectionViewDelegate {

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
    }
}
