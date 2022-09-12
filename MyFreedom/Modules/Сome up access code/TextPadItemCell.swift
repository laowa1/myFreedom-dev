//
//  TextPadItemCell.swift
//  MyFreedom
//
//  Created by m1pro on 09.04.2022.
//

import UIKit

class TextPadItemCell: UICollectionViewCell {

    private let containerView: UIView = build {
        $0.backgroundColor = BaseColor.base50
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
    }
    private let label: UILabel = build {
        $0.tintColor = BaseColor.base800
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()

        label.font = BaseFont.regular.withSize((label.text ?? "").count > 1 ? 17 : 40)
        setNormalState()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        setNormalState()
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += containerView.getLayoutConstraints(over: contentView)
        layoutConstraints += [
            containerView.widthAnchor.constraint(equalToConstant: 64),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ]

        label.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += label.getLayoutConstraintsByCentering(over: containerView)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(text: String) {
        label.text = text
        label.font = BaseFont.regular.withSize((label.text ?? "").count > 1 ? 17 : 40)
    }
}

extension TextPadItemCell: PadItemCellTappable {

    func setTapState() {
        containerView.backgroundColor = BaseColor.base500
        label.textColor = BaseColor.green500
    }

    func setNormalState() {
        containerView.backgroundColor = BaseColor.base50
        label.textColor = BaseColor.base800
    }
}
