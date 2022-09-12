//
//  ProgressView.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import UIKit.UIView

class ProgressView: UIView {

    private lazy var widthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
    private var progressView: UIView = build {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = BaseColor.green500
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func change(to percent: CGFloat = 0) {
        widthConstraint.constant = (UIView.screenWidth - 64) * percent/100
        layoutIfNeeded()
    }

    func removeAnimation() {
        progressView.layer.removeAllAnimations()
        progressView.layoutIfNeeded()
    }

    private func configureSubviews() {
        addSubviews()
        setupLayout()

        layer.cornerRadius = 3
        backgroundColor = BaseColor.base200
    }

    private func addSubviews() {
        addSubview(progressView)
    }

    private func setupLayout() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leftAnchor.constraint(equalTo: leftAnchor),
            widthConstraint
        ])
    }
}
