//
//  FreedomCardView.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import UIKit

class FreedomCardView: UIView {

    var actionButtonPressed: ((_ type: RequisiteClipboardType) -> Void)?

    private var freedomBankLogo: UIImageView = build {
        $0.image = BaseImage.freedomBankColorless.uiImage
    }

    private var cardNumber: UIButton = build {
        $0.setTitle("4400 4509 0980 3097", for: .normal)
        $0.setImage(BaseImage.copy.uiImage(tintColor: .white), for: .normal)
        $0.layer.cornerRadius = 12
        $0.semanticContentAttribute = .forceRightToLeft
        $0.backgroundColor = .white.withAlphaComponent(0.1)
    }

    private var paymentSystemLogo: UIImageView = build {
        $0.image = BaseImage.mastercardColorless.uiImage
    }

    private let cardBottomView: UIView = build {
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.backgroundColor = .white
    }

    private var expiryDate: UIButton = build {
        $0.setTitle("04/27", for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.setTitleColor(BaseColor.base700, for: .normal)
        $0.setImage(BaseImage.copy.uiImage, for: .normal)
        $0.backgroundColor = .clear
    }

    private var cVV: UIButton = build {
        $0.setTitle("CVV", for: .normal)
        $0.backgroundColor = BaseColor.base100
        $0.setTitleColor(BaseColor.base700, for: .normal)
        $0.layer.cornerRadius = 12
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 12
        backgroundColor = BaseColor._00B78D.uiColor

        addSubviews()
        setupLayout()
        addActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        cardBottomView.addSubview(paymentSystemLogo)
        cardBottomView.addSubview(expiryDate)
        cardBottomView.addSubview(cVV)

        addSubview(freedomBankLogo)
        addSubview(cardNumber)
        addSubview(cardBottomView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        freedomBankLogo.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            freedomBankLogo.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            freedomBankLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            freedomBankLogo.heightAnchor.constraint(equalToConstant: 20)
        ]

        cardNumber.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cardNumber.topAnchor.constraint(equalTo: freedomBankLogo.bottomAnchor, constant: 24),
            cardNumber.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardNumber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardNumber.heightAnchor.constraint(equalToConstant: 36)
        ]

        cardBottomView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cardBottomView.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 16),
            cardBottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardBottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBottomView.heightAnchor.constraint(equalToConstant: 60)
        ]

        paymentSystemLogo.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            paymentSystemLogo.centerYAnchor.constraint(equalTo: cardBottomView.centerYAnchor),
            paymentSystemLogo.leadingAnchor.constraint(equalTo: cardBottomView.leadingAnchor, constant: 16),
            paymentSystemLogo.heightAnchor.constraint(equalToConstant: 24),
            paymentSystemLogo.widthAnchor.constraint(equalToConstant: 40)
        ]

        cVV.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cVV.centerYAnchor.constraint(equalTo: cardBottomView.centerYAnchor),
            cVV.trailingAnchor.constraint(equalTo: cardBottomView.trailingAnchor, constant: -16),
            cVV.heightAnchor.constraint(equalToConstant: 36)
        ]

        expiryDate.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            expiryDate.centerYAnchor.constraint(equalTo: cardBottomView.centerYAnchor),
            expiryDate.trailingAnchor.constraint(equalTo: cVV.leadingAnchor, constant: -16),
            expiryDate.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func addActions() {
        cardNumber.addTarget(self, action: #selector(cardNumberPressed), for: .touchUpInside)
        cVV.addTarget(self, action: #selector(cVVPressed), for: .touchUpInside)
    }

    @objc private func cardNumberPressed() {
        UIPasteboard.general.string = cardNumber.currentTitle
        actionButtonPressed?(.cardNumber)
    }

    @objc private func cVVPressed() {
        UIPasteboard.general.string = cVV.currentTitle
        actionButtonPressed?(.cvv)
    }
}

extension FreedomCardView: CleanableView {
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 48) }

    func clean() { }
}
