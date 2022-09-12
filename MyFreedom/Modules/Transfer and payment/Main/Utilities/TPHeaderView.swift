//
//  TPHeaderView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

class TPHeaderView: UIView {

    var rightButtonAction = {}

    lazy var button: UIButton = build {
        $0.setTitleColor(BaseColor.green500, for: .normal)
        $0.titleLabel?.font = BaseFont.semibold.withSize(14)
        $0.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }

    private let titleLabel: UILabel = build {
        $0.font = BaseFont.semibold.withSize(22)
        $0.textColor = BaseColor.base900
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(button)
        setLayoutConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: button.leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        button.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 16),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 16)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func rightButtonTapped() {
        rightButtonAction()
    }

    func set(text: String?) {
        titleLabel.text = text
    }
}

extension TPHeaderView: CleanableView {
    var contentInset: UIEdgeInsets { .init(top: 8, left: 16, bottom: 16, right: 16) }
}

extension TPHeaderView: WrapperHeaderFooterContentView {

    var type: WrapperHeaderFooter { .header }

    var marginTop: CGFloat { 16 }

    var marginBottom: CGFloat { 0 }

    func clean() {
        titleLabel.text = nil
    }
}
