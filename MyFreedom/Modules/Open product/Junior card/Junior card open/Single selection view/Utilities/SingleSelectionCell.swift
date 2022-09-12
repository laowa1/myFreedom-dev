//
//  SingleSelectionView.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import UIKit

class SingleSelectionCell: UITableViewCell {

    static var estimatedRowHeight: CGFloat { 64 }

    private var titleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.medium.withSize(16)
    }

    private let accessoryImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private var innerView: UIView = build {
        $0.backgroundColor = BaseColor.base50
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, accessoryImage])) {
        $0.alignment = .center
        $0.backgroundColor = BaseColor.base50
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSelected(selected: selected)
    }

    func roundTopCorners(radius: CGFloat) {
        innerView.roundTop(radius: radius)
    }

    func roundBottomCorners(radius: CGFloat) {
        innerView.roundBottom(radius: radius)
    }

    private func confgiure() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        innerView.addSubview(stackView)
        contentView.addSubview(innerView)

        stupLayout()
    }

    private func stupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        innerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += innerView.getLayoutConstraints(over: contentView, left: 16, top: 0, right: 16, bottom: 0)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: innerView, left: 16, top: 0, right: 16, bottom: 0)
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 64)]

        accessoryImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryImage.heightAnchor.constraint(equalToConstant: 24),
            accessoryImage.widthAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func setSelected(selected: Bool) {
        accessoryImage.isHidden = !selected
        titleLabel.textColor = selected ? BaseColor.green500 : BaseColor.base900
    }

    func configure(viewModel: SingleSelectionItem) {
        titleLabel.text = viewModel.title
        accessoryImage.image = viewModel.accessoryImage
        setSelected(viewModel.isSelected, animated: false)
    }
}
