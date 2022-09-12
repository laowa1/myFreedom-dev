//
//  BackspacePadItemCell.swift
//  MyFreedom
//
//  Created by m1pro on 09.04.2022.
//

import UIKit

class BackspacePadItemCell: UICollectionViewCell {

    private let containerView: UIView = build {
        $0.backgroundColor = BaseColor.base50
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
    }
    private let imageView: UIImageView = build {
        $0.image = BaseImage.backspace.template
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

        setNormalState()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += containerView.getLayoutConstraints(over: contentView)
        layoutConstraints += [
            containerView.widthAnchor.constraint(equalToConstant: 64),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += imageView.getLayoutConstraintsByCentering(over: containerView)

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension BackspacePadItemCell: PadItemCellTappable {

    func setTapState() {
        containerView.backgroundColor = BaseColor.base500
        imageView.tintColor = BaseColor.green500
    }

    func setNormalState() {
        containerView.backgroundColor = BaseColor.base50
        imageView.tintColor = BaseColor.base800
    }
}
