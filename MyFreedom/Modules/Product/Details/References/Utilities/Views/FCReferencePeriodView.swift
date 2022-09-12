//
//  FCReferencePeriodView.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import UIKit

class FCReferencePeriodView: UIView {
    
    let titleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium
    }

    let subtitleLabel: UILabel = build {
        $0.numberOfLines = 2
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular.withSize(13)
        $0.isHidden = true
    }

    private lazy var labelStack: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
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
        backgroundColor = .white
        stupLayout()
    }

    private func stupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        labelStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += labelStack.getLayoutConstraints(over: self, safe: false, top: 8, bottom: 8)
        layoutConstraints += [labelStack.heightAnchor.constraint(equalToConstant: 44)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: FCReferenceFieldItemElement) {
        titleLabel.text = viewModel.title
        if let subtitle = viewModel.subtitle {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
            labelStack.spacing = 4
        }
    }
}

extension FCReferencePeriodView: WACleanableView {
    
    var label: UILabel { titleLabel } 
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 12) }
    
    func clean() {
        titleLabel.text = nil
        titleLabel.textColor = BaseColor.base800
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
        labelStack.spacing = 0
    }
}
