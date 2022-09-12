//
//  CFConditionsView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class CFConditionsView: UIView {

    let titleLabel: UILabel =  build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.semibold.withSize(22)
        $0.numberOfLines = 0
    }

    let subtitleLabel: UILabel = build {
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium.withSize(14)
        $0.numberOfLines = 0
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubview(stackView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, left: 0, top: 12, right: 0, bottom: 12)

        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension CFConditionsView: CleanableView {
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 16) }

    func clean() {}
}

