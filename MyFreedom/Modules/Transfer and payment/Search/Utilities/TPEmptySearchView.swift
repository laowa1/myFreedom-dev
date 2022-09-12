//
//  TPEmptySearchView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

class TPEmptySearchView: UIView {

    let titleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium
        $0.textAlignment = .center
    }

    let subtitleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular.withSize(13)
        $0.textAlignment = .center
    }

    private lazy var labelStack: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
        $0.spacing = 6
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        confgiure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiure() {
        addSubview(labelStack)
        backgroundColor = .white
        stupLayout()
    }

    private func stupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        labelStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += labelStack.getLayoutConstraints(over: self, safe: false, margin: 16)

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension TPEmptySearchView: CleanableView {

    var contentInset: UIEdgeInsets { .init(top: 4, left: 16, bottom: 8, right: 16) }

    func clean() {
        titleLabel.text = nil
        titleLabel.textColor = BaseColor.base800
        subtitleLabel.text = nil
    }
}
