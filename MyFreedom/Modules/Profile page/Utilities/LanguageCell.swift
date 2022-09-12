//
//  LanguageCell.swift
//  MyFreedom
//
//  Created by m1pro on 15.05.2022.
//

import UIKit

struct LanguagePickerPickerItem: BottomSheetPickerItemProtocol {
    let title: String
    var description: String? = nil
    var isSelected: Bool = false
    var accessoryImage: UIImage? = BaseImage.selection.uiImage
}

class LanguageCell: UITableViewCell, BottomSheetPickerCellProtocol {

    static var estimatedRowHeight: CGFloat { 46 }

    private var titleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium
    }

    private let accessoryImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, accessoryImage])) {
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let view = self else { return }
            view.setSelected(selected: selected)
        }
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
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 46)]

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

    func configure(viewModel: LanguagePickerPickerItem) {
        titleLabel.text = viewModel.title
        accessoryImage.image = viewModel.accessoryImage
        setSelected(selected: viewModel.isSelected)
    }
}
