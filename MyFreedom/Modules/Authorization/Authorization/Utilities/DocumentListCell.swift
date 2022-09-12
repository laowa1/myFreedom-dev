//
//  DocumentListCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 05.04.2022.
//

import UIKit

class DocumentListCell: UITableViewCell, BottomSheetPickerCellProtocol {

    static var estimatedRowHeight: CGFloat { 52 }

    private let itemIcon: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private var itemTitle: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium.withSize(14)
    }

    private let accessoryImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [itemIcon, itemTitle, accessoryImage])) {
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
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 52)]

        itemIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            itemIcon.heightAnchor.constraint(equalToConstant: 24),
            itemIcon.widthAnchor.constraint(equalToConstant: 24)
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
        itemIcon.image = viewModel.image
        accessoryImage.image = viewModel.accessoryImage
    }
}
