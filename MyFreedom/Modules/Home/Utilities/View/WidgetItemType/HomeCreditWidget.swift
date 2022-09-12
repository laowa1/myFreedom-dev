//
//  HomeCreditWidget.swift
//  MyFreedom
//
//  Created by &&TairoV on 31.05.2022.
//

import UIKit

class HomeCreditsWidgets: UIView {

    private let titleLabel = PaddingLabel()
    private let amountLabel = PaddingLabel()
    private let actionButton = UIButton()

    private lazy var contentStackView: UIStackView = build(UIStackView(arrangedSubviews: [infoStackView, actionButton])) {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }

    private lazy var infoStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, amountLabel])) {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setuplayout()
        stylize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: WidgetViewModel, buttonTitle: String?) {
        actionButton.setTitle(buttonTitle, for: .normal)
        titleLabel.text = model.title
        amountLabel.text = model.amount
    }

    private func addSubviews() {
        addSubview(contentStackView)
    }

    private func setuplayout() {
        var layoutConstrints = [NSLayoutConstraint]()

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            actionButton.widthAnchor.constraint(equalToConstant: 88),
            actionButton.heightAnchor.constraint(equalToConstant: 30)
        ]

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += contentStackView.getLayoutConstraints(over: self, left: 16, top: 16, right: 16, bottom: 16)

        NSLayoutConstraint.activate(layoutConstrints)
    }

    private func stylize() {
        backgroundColor = .white
        layer.cornerRadius = 12

        actionButton.backgroundColor = BaseColor.green500
        actionButton.layer.cornerRadius = 16
        actionButton.titleLabel?.font = BaseFont.medium.withSize(13)

        titleLabel.text = "Ежемесячный платеж до 18 апреля"
        titleLabel.textAlignment = .left
        titleLabel.font = BaseFont.regular.withSize(11)
        titleLabel.textColor = BaseColor.base500

        amountLabel.font = BaseFont.regular.withSize(16)
        amountLabel.text = "12 450,00 ₸"
        amountLabel.textAlignment = .left
        amountLabel.textColor = .black
    }
}

extension HomeCreditsWidgets: CleanableView {

    func clean() { }
}
