//
//  DepositAwardsDetailView.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import UIKit

class DepositRewardsDetailView: UIView {

    let titleLabel: PaddingLabel = build {
        $0.font = BaseFont.semibold.withSize(16)
        $0.textColor = BaseColor.base800
    }

    let descriptionLabel: PaddingLabel = build {
        $0.font = BaseFont.semibold.withSize(16)
        $0.textColor = BaseColor.green500
        $0.textAlignment = .right
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])) {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubview(stackView)
        stackView.layout(over: self, top: 16, bottom: 16)
    }
}

extension DepositRewardsDetailView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }

    func clean() { }
}
