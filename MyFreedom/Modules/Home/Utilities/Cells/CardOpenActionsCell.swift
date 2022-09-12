//
//  OpenCardActionsCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 03.05.2022.
//

import UIKit

class CardOpenActionsCell: UITableViewCell, BottomSheetPickerCellProtocol {

    static var estimatedRowHeight: CGFloat { 66 }

    private let itemIcon: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private var itemTitle: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium.withSize(16)
    }

    private var descriptionLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.regular.withSize(13)
    }

    private let accessoryImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private lazy var messageStackView: UIStackView = build(UIStackView(arrangedSubviews: [itemTitle, descriptionLabel])) {
        $0.axis = .vertical
        $0.alignment = .fill
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [itemIcon, messageStackView, accessoryImage])) {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 8
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        confgiure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiure() {
        contentView.addSubview(stackView)
        contentView.backgroundColor = .clear
        let backgroundView = UIView()
        backgroundView.backgroundColor = BaseColor.base100
        selectedBackgroundView = backgroundView
        stupLayout()
    }

    private func stupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: contentView, safe: false, left: 16, top: 0, right: 16, bottom: 0)
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 66)]

        itemIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            itemIcon.heightAnchor.constraint(equalToConstant: 40),
            itemIcon.widthAnchor.constraint(equalToConstant: 40)
        ]

        accessoryImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryImage.heightAnchor.constraint(equalToConstant: 24),
            accessoryImage.widthAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: BasePickerPickerItem) {
        itemTitle.text = viewModel.title
        descriptionLabel.text = viewModel.description
        itemIcon.image = viewModel.image
        accessoryImage.image = viewModel.accessoryImage
    }
}
