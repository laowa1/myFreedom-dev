//
//  BannerImage66ItemCell.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

class BannerImage66ItemCell: UICollectionViewCell {

    var imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
    }

    var titleLabel: UILabel = build {
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium.withSize(11)
        $0.numberOfLines = 3
        $0.textAlignment = .center
    }

    private lazy var imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 60)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.applyShadow(alpha: 0.03)
    }

    private func configureSubviews() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .clear
        addSubviews()
        setupLayout()
    }

    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
            imageWidthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func set(height: CGFloat) {
        imageWidthConstraint.constant = height
        imageView.layoutIfNeeded()
    }
}
