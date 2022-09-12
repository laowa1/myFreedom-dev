//
//  DepositAwardsPeriodSelectionVeiw.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import UIKit

class DepositRewardsTotalVeiw: UIView {

    var buttonTapped: (() -> Void)?

    private let backgroundImage: UIImageView = build {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
        $0.image = BaseImage.pdReward.uiImage
    }

    let awardsTotalLabel: PaddingLabel = build {
        $0.font = BaseFont.semibold.withSize(28)
        $0.textColor = BaseColor.base50
    }

    let rewardsPrecentage: PaddingLabel = build {
        $0.textColor = BaseColor.green500
        $0.backgroundColor = BaseColor.base50
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = BaseFont.semibold.withSize(18)
        $0.insets = .init(top: 0, left: 8, bottom: 0, right: 8)
    }

    let periodSelection: UIButton = build {
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = BaseFont.medium.withSize(14)
        $0.setTitleColor(BaseColor.base900, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.backgroundColor = BaseColor.base100
        $0.setTitle("За все время", for: .normal)
        $0.setImage(BaseImage.chevronBottom.uiImage, for: .normal)
        $0.imageEdgeInsets.left = 4
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    private lazy var rewardsStack: UIStackView = build(UIStackView(arrangedSubviews: [awardsTotalLabel, rewardsPrecentage])){
        $0.axis = .horizontal
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
        addSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        backgroundColor = .clear
        layer.cornerRadius = 16

        periodSelection.addTarget(self, action: #selector(periodSelectionTapped), for: .touchUpInside)
    }

    private func addSubviews() {
        addSubview(backgroundImage)
        addSubview(rewardsStack)
        addSubview(periodSelection)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += backgroundImage.getLayoutConstraints(over: self)

        awardsTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        awardsTotalLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        rewardsStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            rewardsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            rewardsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rewardsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ]

        rewardsPrecentage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            rewardsPrecentage.heightAnchor.constraint(equalToConstant: 32)
        ]

        periodSelection.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            periodSelection.topAnchor.constraint(equalTo: rewardsStack.bottomAnchor, constant: 16),
            periodSelection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            periodSelection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            periodSelection.heightAnchor.constraint(equalToConstant: 36)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc func periodSelectionTapped() {
        buttonTapped?()
    }
}

extension DepositRewardsTotalVeiw: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }

    func clean() { }
}
