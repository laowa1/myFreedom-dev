//
//  PreviewONIViewContoller.swift
//  MyFreedom
//
//  Created by m1 on 10.07.2022.
//

import UIKit

protocol PreviewNewInvestViewInput: BaseViewController, BaseDrawerContentViewControllerProtocol { }

class PreviewNewInvestViewContoller: BaseViewController {

    var router: PreviewNewInvestRouterInput?

    private var headerView = BackdropHeaderView()
    private let imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.image = BaseImage.openNewInvestPlaceholder.uiImage
    }
    private lazy var nextButton: BaseButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Выбрать дизайн карты", for: .normal)
    }
    private lazy var chooseButton: BaseButton = build(ButtonFactory().getNotAcceptButton()) {
        $0.setTitle("Продолжить без персонализации", for: .normal)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        style()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(imageView)
        view.addSubviews(nextButton, chooseButton)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        headerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56)
        ]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ]

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            nextButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ]

        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            chooseButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 16),
            chooseButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            chooseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 52)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func style() {
        view.roundTop(radius: 16)
        view.backgroundColor = BaseColor.base50
        headerView.configure(title: "Открыть новый продукт") { [weak self] in
            self?.router?.routeToBack()
        }
    }

    private func setActions() {
        nextButton.actionClick = ActionClick(block: { [weak self] sender in
            self?.router?.routeToNext()
        })
        chooseButton.actionClick = ActionClick(block: { [weak self] sender in
            self?.router?.routeToNext()
        })
    }
}

extension PreviewNewInvestViewContoller: PreviewNewInvestViewInput {

    var contentViewHeight: CGFloat { 380 }
}
