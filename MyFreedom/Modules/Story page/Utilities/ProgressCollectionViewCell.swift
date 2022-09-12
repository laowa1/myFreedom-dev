//
//  CurrentStoryCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 10.03.2022.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    private lazy var widthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
    private var progressView: UIView = build {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .white.withAlphaComponent(0.75)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.layer.removeAllAnimations()
        progressView.layoutIfNeeded()
    }

    func changeWidth(to size: Int = 0) {
        widthConstraint.constant = size > 0 ? contentView.frame.width : 0
        layoutIfNeeded()
    }

    func removeAnimation() {
        progressView.layer.removeAllAnimations()
        progressView.layoutIfNeeded()
    }

    private func configureSubviews() {
        addSubviews()
        setupLayout()

        layer.cornerRadius = 2
        backgroundColor = .white.withAlphaComponent(0.3)
    }

    private func addSubviews() {
        contentView.addSubview(progressView)
    }

    private func setupLayout() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            progressView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            widthConstraint
        ])
    }
}
