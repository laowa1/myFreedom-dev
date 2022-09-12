//
//  PDLimitsDisableView.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import UIKit

class PDLimitsDisableView: UIView {

    private lazy var topView: UIView = build {
        $0.addSubviews(titleButton, toogleButton)
    }

    let titleButton: UIButton = build(ButtonFactory().getTextButton()) {
        $0.setTitleColor(BaseColor.base700, for: .normal)
        $0.setImage(BaseImage.limits_cloud.uiImage, for: .normal)
        $0.imageEdgeInsets.left = -10
    }
    
    let toogleButton: UIButton = build(ButtonFactory().getTextButton()) {
        $0.setTitle("Включить", for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        confgiureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiureSubviews() {
        layer.cornerRadius = 12
        backgroundColor = BaseColor.base50
        addSubview(topView)
        setupLayout()
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        topView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += topView.getLayoutConstraints(over: self, safe: false, margin: 16)
        layoutConstraints += [topView.heightAnchor.constraint(equalToConstant: 24)]
        
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleButton.topAnchor.constraint(equalTo: topView.topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            titleButton.leftAnchor.constraint(equalTo: topView.leftAnchor)
        ]
        
        toogleButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            toogleButton.topAnchor.constraint(equalTo: titleButton.topAnchor),
            toogleButton.bottomAnchor.constraint(equalTo: titleButton.bottomAnchor),
            toogleButton.rightAnchor.constraint(equalTo: topView.rightAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: PDLimitsElement) {
        titleButton.setTitle(viewModel.title, for: .normal)
    }
}

extension PDLimitsDisableView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 8, left: 16, bottom: 8, right: 16) }
    
    var containerBackgroundColor: UIColor { BaseColor.base100 }
    
    func clean() {
        titleButton.setTitle(nil, for: .normal)
    }
}
