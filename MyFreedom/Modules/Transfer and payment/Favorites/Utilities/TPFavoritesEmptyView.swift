//
//  TPFavoritesEmptyView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

class TPFavoritesEmptyView: UIView {

    let imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
    }

    let titleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base500
        $0.font = BaseFont.medium
        $0.textAlignment = .center
    }

    private lazy var labelStack: UIStackView = build(UIStackView(arrangedSubviews: [imageView, titleLabel])) {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 6
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        confgiure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiure() {
        addSubview(labelStack)
        backgroundColor = BaseColor.base50
        stupLayout()
    }

    private func stupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        labelStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += labelStack.getLayoutConstraints(over: self, safe: false, margin: 16)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.widthAnchor.constraint(equalToConstant: 49),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension TPFavoritesEmptyView: CleanableView {

    var contentInset: UIEdgeInsets { .init(top: 4, left: 0, bottom: 8, right: 0) }

    func clean() {
        imageView.image = nil
        titleLabel.text = nil
    }
}
