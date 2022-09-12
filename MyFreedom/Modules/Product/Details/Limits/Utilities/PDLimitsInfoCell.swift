//
//  PDLimitsInfoCell.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//


import UIKit

struct PDLimitsInfoItem: BottomSheetPickerItemProtocol {
    let title: String = "⬤ ● • ⚫ 🌑"
    var description: String? = nil
}

class PDLimitsInfoCell: UITableViewCell, BottomSheetPickerCellProtocol {

    static var estimatedRowHeight: CGFloat { 44 }

    private var titleLabel: UILabel = build {
        $0.numberOfLines = 1
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.regular.withSize(7)
        $0.textAlignment = .center
        $0.text = "●"
    }

    private var descriptionLabel: UILabel = build {
        $0.numberOfLines = 0
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.regular
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])) {
        $0.alignment = .top
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
        stupLayout()
    }

    private func stupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: contentView, safe: false, left: 16, top: 4, right: 16, bottom: 4)
        layoutConstraints += [stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: PDLimitsInfoItem) {
        descriptionLabel.text = viewModel.description
    }
}
