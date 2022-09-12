//
//  SelectionCollectionViewCell.swift
//  MyFreedom
//
//  Created by m1 on 07.07.2022.
//

import UIKit

struct SelectionItemModel: Equatable {
    var title: String
    var isSelected: Bool = false
}

class SelectionItemCollectionViewCell: UICollectionViewCell {

    private let titleLabel = PaddingLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        stylize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addSubviews()
        stylize()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.backgroundColor = .clear
        titleLabel.text = nil
    }

    // MARK: - Public

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        titleLabel.layout(over: self, safe: false)
    }

    private func stylize() {
        contentView.layer.borderColor = BaseColor.base700.cgColor
        contentView.backgroundColor = BaseColor.base50
        titleLabel.layer.cornerRadius = 12
        titleLabel.layer.borderWidth = 1

        titleLabel.font = BaseFont.medium.withSize(14)
        titleLabel.insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

    // MARK: - Public
    func configure(with viewModel: SelectionItemModel) {
        titleLabel.layer.borderWidth = viewModel.isSelected ? 1 : 0
        titleLabel.text = viewModel.title
        titleLabel.backgroundColor = viewModel.isSelected ? BaseColor.base800 : .clear
        titleLabel.textColor = viewModel.isSelected ? BaseColor.base50 : BaseColor.base700
    }
}
