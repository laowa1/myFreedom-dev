//
//  TPFavoritesItemView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

class TPFavoritesItemView: UIView {

    let iconView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let dotsView = UIButton()
    private lazy var stackHeight = self.heightAnchor.constraint(equalToConstant: 40)

    private lazy var mainStackView: UIStackView = build(UIStackView(arrangedSubviews: [iconView, infoStackView])) {
        $0.spacing = 12
        $0.alignment = .center
        $0.axis = .horizontal
    }

    private lazy var infoStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
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
        addSubview(mainStackView)
        addSubview(dotsView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconView.heightAnchor.constraint(equalToConstant: 32),
            iconView.widthAnchor.constraint(equalToConstant: 32)
        ]

        dotsView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            dotsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dotsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dotsView.widthAnchor.constraint(equalToConstant: 24),
            dotsView.heightAnchor.constraint(equalToConstant: 24)
        ]

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: dotsView.leadingAnchor, constant: -12),
            stackHeight
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        titleLabel.font = BaseFont.semibold.withSize(14)
        titleLabel.textColor = BaseColor.base800

        subtitleLabel.font = BaseFont.regular.withSize(11)
        subtitleLabel.textColor = BaseColor.base500
    }
}

extension TPFavoritesItemView: CleanableView {

    var contentInset: UIEdgeInsets { .init(top: 16, left: 16, bottom: 16, right: 16) }

    var containerBackgroundColor: UIColor { BaseColor.base50 }

    func clean() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        iconView.image = nil
    }
}
