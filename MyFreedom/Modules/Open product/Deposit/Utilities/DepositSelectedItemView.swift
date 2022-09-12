//
//  DepositSelectedItemView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

struct DepositItem: Equatable {
    let currency: CurrencyType
    let term: String
}

class DepositSelectedItemView: UIView {

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let dotsView = UIButton()
    private lazy var stackHeight = self.heightAnchor.constraint(equalToConstant: 40)

    private lazy var infoStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, bottomView])) {
        $0.axis = .vertical
        $0.spacing = 16
    }

    private lazy var bottomView: UIView = build {
        $0.addSubview(bottomStackView)
    }

    private lazy var bottomStackView: UIStackView = build {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubviews()
        setupLayout()
        stylize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(infoStackView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            infoStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            infoStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ]

        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            bottomStackView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomStackView.leftAnchor.constraint(equalTo: bottomView.leftAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = BaseColor.base50

        titleLabel.font = BaseFont.semibold.withSize(22)
        titleLabel.textColor = BaseColor.base800

        subtitleLabel.font = BaseFont.medium.withSize(14)
        subtitleLabel.textColor = BaseColor.base800
        subtitleLabel.numberOfLines = 0
    }

    func configure(items: [DepositItem]) {
        items.forEach { item in
            let titleButton: UIButton = build(ButtonFactory().getTextButton()) {
                $0.setTitleColor(BaseColor.base800, for: .normal)
                $0.titleLabel?.font = BaseFont.medium
                $0.setImage(BaseImage.kzt.uiImage, for: .normal)
                $0.imageEdgeInsets.left = -4
                $0.setTitle(item.term, for: .normal)
            }
            bottomStackView.addArrangedSubview(titleButton)
        }

    }
}

extension DepositSelectedItemView: CleanableView {

    var contentInset: UIEdgeInsets { .init(top: 12, left: 16, bottom: 16, right: 12) }

    func clean() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        bottomStackView.removeAllArrangedSubviews()
    }
}
