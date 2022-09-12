//
//  CleanableImageView.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//

import UIKit

class CleanableImageView: UIView {

    let imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    lazy var stackView: UIStackView = build {
        $0.spacing = 8
        $0.alignment = .top
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.addArrangedSubviews(titleLabel, appleIconView)
    }

    let titleLabel: PaddingLabel = build {
        $0.font = BaseFont.bold.withSize(32)
        $0.textColor = BaseColor.base900
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.textAlignment = .center
        $0.text = "Invest Card"
    }

    let appleIconView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.image = BaseImage.appleIcon.uiImage
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubviews(imageView, stackView)

        var layoutConstraints = [NSLayoutConstraint]()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
        ]

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension CleanableImageView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }

    func clean() { }
}
