//
//  EPContactCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 05.07.2022.
//

import UIKit
import Contacts

class EPContactView: UIView {

    var contact: EPContact?

    let titleLabel: PaddingLabel = build {
        $0.font = BaseFont.medium.withSize(16)
        $0.textColor = BaseColor.base800
    }

    let subtitleLabel: PaddingLabel = build {
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base500
    }

    let headTitleButton: UIButton = build {
        $0.titleLabel?.font = BaseFont.semibold.withSize(14)
        $0.setTitleColor(BaseColor.base50, for: .normal)
        $0.layer.cornerRadius = 12
    }

    private let colorArray = [EPGlobalConstants.Colors.amethystColor,EPGlobalConstants.Colors.asbestosColor,EPGlobalConstants.Colors.emeraldColor,EPGlobalConstants.Colors.peterRiverColor,EPGlobalConstants.Colors.pomegranateColor,EPGlobalConstants.Colors.pumpkinColor,EPGlobalConstants.Colors.sunflowerColor]

    private lazy var nameStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
    }

    private lazy var contentStackView: UIStackView = build(UIStackView(arrangedSubviews: [headTitleButton, nameStackView])) {
        $0.spacing = 12
        $0.axis = .horizontal
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
        backgroundColor = .clear
        addSubview(contentStackView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += contentStackView.getLayoutConstraints(over: self, left: 16, top: 12, right: 16, bottom: 12)

        headTitleButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            headTitleButton.heightAnchor.constraint(equalToConstant: 32),
            headTitleButton.widthAnchor.constraint(equalToConstant: 32)
        ]

        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: EPContact, _ indexpath: IndexPath) {
        let randomValue = (indexpath.row + indexpath.section) % colorArray.count
        titleLabel.text = viewModel.displayName()
        subtitleLabel.text = viewModel.phoneNumbers.first?.phoneNumber
        headTitleButton.setTitle(viewModel.contactInitials(), for: .normal)
        headTitleButton.backgroundColor = colorArray[randomValue]
    }

    func setEmpty(title: String?, subtitle: String?) {
        contentStackView.spacing = 0
        headTitleButton.constraints.forEach({ $0.isActive = false })
        headTitleButton.isHidden = true

        titleLabel.text = title
        titleLabel.font = BaseFont.medium.withSize(16)
        titleLabel.textColor = BaseColor.base900

        subtitleLabel.text = subtitle
        subtitleLabel.font = BaseFont.regular.withSize(13)
        subtitleLabel.textColor = BaseColor.base700
    }
}

extension EPContactView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }

    func clean() { }
}
