//
//  AccessoryView.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/11/22.
//

import UIKit

class AccessoryView: UIView {

    let iconView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let captionLabel = UILabel()
    let accessoryView = UIImageView()
    private lazy var stackHeight = self.heightAnchor.constraint(equalToConstant: 40)

    private lazy var mainStackView: UIStackView = build(UIStackView(arrangedSubviews: [iconView, infoStackView, captionLabel])) {
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
        addSubview(accessoryView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconView.heightAnchor.constraint(equalToConstant: 32),
            iconView.widthAnchor.constraint(equalToConstant: 32)
        ]

        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoryView.widthAnchor.constraint(equalToConstant: 24),
            accessoryView.heightAnchor.constraint(equalToConstant: 24)
        ]

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -12),
            stackHeight
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        titleLabel.font = BaseFont.medium.withSize(16)
        titleLabel.textColor = .black

        subtitleLabel.font = BaseFont.regular.withSize(13)
        subtitleLabel.textColor = BaseColor.base500

        captionLabel.font = BaseFont.regular.withSize(13)
        captionLabel.textColor = BaseColor.base700
        captionLabel.textAlignment = .right
    }
}

extension AccessoryView: CleanableView {

    @objc var contentInset: UIEdgeInsets { .init(top: 4, left: 16, bottom: 4, right: 16) }

    func clean() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        captionLabel.text = nil
        iconView.image = nil
        stackHeight.constant = 40
    }
}

class Accessory16MarginView: AccessoryView {
    override var contentInset: UIEdgeInsets { .init(top: 16, left: 16, bottom: 16, right: 16) }
}
