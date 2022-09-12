//
//  BottomTermsView.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.07.2022.
//

import UIKit

class ButtonTermsView: UIView {

    var buttonTapped: (() -> Void)?

    let actionButton: UIButton = build {
        $0.titleLabel?.font = BaseFont.semibold.withSize(18)
        $0.layer.cornerRadius = 16
        $0.setTitleColor(BaseColor.base50, for: .normal)
        $0.backgroundColor = BaseColor.green500
    }

    let termsLabel: UILabel =  build {
        $0.text = nil
        $0.textColor = BaseColor.base500
        $0.textAlignment = .center
        $0.font = BaseFont.semibold.withSize(13)
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [actionButton, termsLabel])) {
        $0.axis = .vertical
        $0.spacing = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
        setupLayout()

        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubview(stackView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self)

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            actionButton.heightAnchor.constraint(equalToConstant: 52)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func buttonAction() {
        buttonTapped?()
    }
}

extension ButtonTermsView: CleanableView {
    
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }

    func clean() { }
}
