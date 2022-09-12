//
//  RecentOperationsView.swift
//  MyFreedom
//
//  Created by m1pro on 30.05.2022.
//

import UIKit

final class RecentOperationsView: UIView {
    
    let iconView: UIImageView = build {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = BaseColor.green500.withAlphaComponent(0.2)
    }
    private lazy var titleVerticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(titleLabel, subtitleLabel)
    }
    let titleLabel: UILabel = build {
        $0.font = BaseFont.semibold
        $0.textColor = BaseColor.base800
    }
    let subtitleLabel: UILabel = build {
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base700
    }
    private lazy var descriptionVerticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(amountLabel, descriptionLabel)
    }
    let amountLabel: UILabel = build {
        $0.font = BaseFont.semibold
        $0.textColor = BaseColor.base800
        $0.textAlignment = .right
    }
    let descriptionLabel: UILabel = build {
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base700
        $0.textAlignment = .right
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(iconView)
        addSubview(titleVerticalStack)
        addSubview(descriptionVerticalStack)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32)
        ]
    
        titleVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleVerticalStack.topAnchor.constraint(equalTo: topAnchor),
            titleVerticalStack.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12),
            titleVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        descriptionVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionVerticalStack.leftAnchor.constraint(equalTo: titleVerticalStack.rightAnchor),
            descriptionVerticalStack.topAnchor.constraint(equalTo: topAnchor),
            descriptionVerticalStack.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionVerticalStack.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension RecentOperationsView: CleanableView {
    
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) }
    func clean() {}
}
