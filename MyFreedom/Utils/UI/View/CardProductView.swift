//
//  CardProductView.swift
//  MyFreedom
//
//  Created by Sanzhar on 03.05.2022.
//

import UIKit

final class CardProductView: UIView {
    
    private let iconView = UIView()
    private let cardIconBackground = UIView()
    private let cardIcon = UIImageView()
    private let titleLabel: UILabel = build {
        $0.font = BaseFont.semibold
        $0.textColor = BaseColor.base800
    }
    private let subtitleLabel: UILabel = build {
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base700
    }
    private let applePayIcon: UIImageView = build {
        $0.image = BaseImage.applePay.uiImage
        $0.isHidden = true
    }
    private let amountLabel: UILabel = build {
        $0.font = BaseFont.semibold
        $0.textColor = BaseColor.base800
        $0.textAlignment = .right
    }
    private let lockIcon: UIImageView = build {
        $0.image = BaseImage.lockClosed.uiImage
        $0.isHidden = true
    }
    private lazy var amountStack: UIStackView = build {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
        $0.addArrangedSubviews([amountLabel, lockIcon])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        cardIcon.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 3.2, blur: 12.81, spread: 0)
    }
    
    private func addSubviews() {
        addSubview(cardIconBackground)
        cardIconBackground.addSubview(cardIcon)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(applePayIcon)
        addSubview(amountStack)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        cardIconBackground.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cardIconBackground.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardIconBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardIconBackground.widthAnchor.constraint(equalToConstant: 32),
            cardIconBackground.heightAnchor.constraint(equalToConstant: 21.33)
        ]
        
        cardIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += cardIcon.getLayoutConstraints(over: cardIconBackground)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: cardIconBackground.rightAnchor, constant: 12)
        ]
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ]
        
        applePayIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            applePayIcon.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4),
            applePayIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        
        amountStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            amountStack.topAnchor.constraint(equalTo: topAnchor),
            amountStack.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            lockIcon.widthAnchor.constraint(equalToConstant: 16),
            lockIcon.heightAnchor.constraint(equalTo: lockIcon.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configure(model: HomeFieldItemElement) {
        
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        cardIcon.image = model.icon?.uiImage
        
        applePayIcon.isHidden = model.connectedToApplePay ? false : true
        lockIcon.isHidden = model.isActive ? true : false

        if let modelAmout = model.amount {
            modelAmout.amount.visableAmount.map { amountLabel.text = $0 + " " + modelAmout.currency.symbol }
            
            if model.isActive {
                amountLabel.textColor = modelAmout.amount > 0 ? BaseColor.base800 : BaseColor.red500
            } else {
                amountLabel.textColor = BaseColor.base500
            }
        }
    }
}

extension CardProductView: CleanableView {
    
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) }
    func clean() {}
}
