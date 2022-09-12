//
//  AuthorizhationMethodCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.03.2022.
//

import UIKit

class BasePickerItemCell: UITableViewCell, BottomSheetPickerCellProtocol {

    static var estimatedRowHeight: CGFloat { 40 }

    private let itemIcon: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private var itemTitle: UILabel = build {
        $0.textColor = BaseColor.base500
        $0.font = BaseFont.regular.withSize(13)
        $0.numberOfLines = 2
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [itemIcon, itemTitle])) {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 20
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
        stupLayout()
    }

    private func stupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: contentView, safe: false, left: 18, top: 0, right: 18, bottom: 0)
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 40)]
        
        itemIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            itemIcon.heightAnchor.constraint(equalToConstant: 20),
            itemIcon.widthAnchor.constraint(equalToConstant: 20)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: BasePickerPickerItem) {
        itemTitle.text = viewModel.title
        itemIcon.image = viewModel.image
    }
}
