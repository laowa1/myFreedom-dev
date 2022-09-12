//
//  StoryContentCollectionViewCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.03.2022.
//

import UIKit

class StoryContentCollectionViewCell: UICollectionViewCell {

    private let titleLebel = PaddingLabel()
    private let subtitleLabel = PaddingLabel()
    private let contentImage = UIImageView()

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLebel, subtitleLabel])) {
        $0.axis = .vertical
        $0.spacing = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayout()
        stylize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(contentImage)
        contentView.addSubview(stackView)
    }

    private func setupLayout() {
        var layoutConstrints = [NSLayoutConstraint]()

        contentImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += contentImage.getLayoutConstraints(over: contentView, safe: false)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 62),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ]

        NSLayoutConstraint.activate(layoutConstrints)
    }

    private func stylize() {
        contentImage.contentMode = .scaleAspectFill

        titleLebel.font = BaseFont.bold.withSize(28)
        titleLebel.textColor = BaseColor.base900

        subtitleLabel.font = BaseFont.semibold.withSize(18)
        subtitleLabel.textColor = BaseColor.base800
    }

    func setContent(data: StoryItem) {
        titleLebel.text = data.title
        subtitleLabel.text = data.subtitle
        contentImage.image = data.image.uiImage
    }
}
