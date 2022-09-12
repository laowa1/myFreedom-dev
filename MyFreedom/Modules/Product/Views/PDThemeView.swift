//
//  PDThemeView.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.06.2022.
//

import UIKit

struct PDThemeViewModel: Equatable {
    let title: String
    let image: BaseImage
}

class PDThemeView: UIView {

    private lazy var circleView: UIView = build {
        $0.layer.borderWidth = 2.5
        $0.layer.cornerRadius = 28
        $0.layer.borderColor = BaseColor.base50.cgColor
        $0.layer.insertSublayer(gradientLayer, at: 0)
    }

    private let selectionImageView: UIImageView = build {
        $0.isHidden = false
        $0.contentMode = .scaleAspectFill
        $0.image = BaseImage.selected.uiImage
    }

    let gradientLayer: CAGradientLayer = build {
        $0.locations = [0, 1]
        $0.startPoint = CGPoint(x: 1, y: 0)
        $0.endPoint = CGPoint(x: 0, y: 1)
        $0.cornerRadius = 28
        $0.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = circleView.bounds

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        backgroundColor = .clear
        addSubview(circleView)
        addSubview(selectionImageView)

        var layoutConstraints =  [NSLayoutConstraint]()

        circleView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += circleView.getLayoutConstraintsByCentering(over: self)

        layoutConstraints += [
            circleView.heightAnchor.constraint(equalToConstant: 56),
            circleView.widthAnchor.constraint(equalToConstant: 56)
        ]

        selectionImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += selectionImageView.getLayoutConstraintsByCentering(over: self)
        layoutConstraints += [
            selectionImageView.heightAnchor.constraint(equalToConstant: 44),
            selectionImageView.widthAnchor.constraint(equalToConstant: 44)
        ]


        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(gradientColors: [BaseColor],  isSelected: Bool = false) {
        gradientLayer.colors = gradientColors.map { $0.cgColor }

        selectionImageView.isHidden = !isSelected
        circleView.isHidden = isSelected
    }
}

extension PDThemeView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }

    func clean() { }
}

