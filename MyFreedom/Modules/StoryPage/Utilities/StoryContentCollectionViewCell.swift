//
//  StoryContentCollectionViewCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.03.2022.
//

import UIKit

class StoryContentCollectionViewCell: UICollectionViewCell {

    private let contentImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        contentImage.contentMode = .scaleAspectFill
        contentView.addSubview(contentImage)
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(contentImage.getLayoutConstraints(over: contentView, safe: false))
    }

    func setContentImage(image: UIImage?) {
        contentImage.image = image
    }
}
