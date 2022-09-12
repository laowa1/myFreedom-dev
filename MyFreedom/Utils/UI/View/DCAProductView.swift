//
//  DCAProductView.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.05.2022.
//

import UIKit

final class DCAProductView: UIView {
    private let productIconBackground: UIView = build {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = BaseColor.green500.withAlphaComponent(0.2)
    }
    private let productIcon = UIImageView()
    private let titleLabel: UILabel = build {
        $0.font = BaseFont.semibold
        $0.textColor = BaseColor.base800
    }
    private let subtitleLabel: UILabel = build {
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base700
    }
    private let amountLabel: UILabel = build {
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base800
        $0.textAlignment = .right
    }
    private let lockIcon = UIImageView(image: BaseImage.lockClosed.uiImage)
    private lazy var amountStack: UIStackView = build {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
        $0.addArrangedSubviews([amountLabel, lockIcon])
    }
    private let maturityDateLabel: UILabel = build {
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
        addSubview(productIconBackground)
        productIconBackground.addSubview(productIcon)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(amountStack)
        addSubview(maturityDateLabel)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        productIconBackground.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            productIconBackground.centerYAnchor.constraint(equalTo: centerYAnchor),
            productIconBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            productIconBackground.widthAnchor.constraint(equalToConstant: 32),
            productIconBackground.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        productIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            productIcon.centerYAnchor.constraint(equalTo: productIconBackground.centerYAnchor),
            productIcon.centerXAnchor.constraint(equalTo: productIconBackground.centerXAnchor),
            productIcon.widthAnchor.constraint(equalToConstant: 20),
            productIcon.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: productIconBackground.rightAnchor, constant: 12)
        ]
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ]
        
        amountStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            amountStack.topAnchor.constraint(equalTo: topAnchor),
            amountStack.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        maturityDateLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            maturityDateLabel.topAnchor.constraint(equalTo: amountStack.bottomAnchor),
            maturityDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            maturityDateLabel.rightAnchor.constraint(equalTo: amountStack.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    
    func configure(model: HomeFieldItemElement) {
        
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        productIcon.image = model.icon?.uiImage
        
        lockIcon.isHidden = model.isActive ? true : false

        if let modelAmout = model.amount {
            modelAmout.amount.visableAmount.map { amountLabel.text = $0 + " " + modelAmout.currency.symbol }
            
            if model.isActive {
                amountLabel.textColor = modelAmout.amount > 0 ? BaseColor.base800 : BaseColor.red500
            } else {
                amountLabel.textColor = BaseColor.base500
            }
        }
        
        model.maturityDate.map { maturityDateLabel.text = $0 }
    }
}

extension DCAProductView: CleanableView {
    
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) }
    func clean() {}
}
