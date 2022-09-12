//
//  ProductListAddFooterView.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.05.2022.
//

import UIKit

final class ProductListAddFooterView: UIView {
    
    private let iconBackgroundView: UIView = build {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = BaseColor.green500.withAlphaComponent(0.2)
//        $0.backgroundColor = .red
    }
    private let addItemIcon: UIImageView = build {
        $0.image = BaseImage.plusGreen.uiImage
    }
    private let titleLabel: UILabel = build {
        $0.font = BaseFont.semibold.withSize(14)
        $0.textColor = BaseColor.green500
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addSubviews() {
        addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(addItemIcon)
        addSubview(titleLabel)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 32),
            iconBackgroundView.heightAnchor.constraint(equalTo: iconBackgroundView.widthAnchor)
        ]
        
        addItemIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            addItemIcon.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            addItemIcon.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leftAnchor.constraint(equalTo: iconBackgroundView.rightAnchor, constant: 12),
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func set(text: String?) {
        titleLabel.text = text
    }
}

extension ProductListAddFooterView: WrapperHeaderFooterContentView {

    var type: WrapperHeaderFooter { .footer }

    var marginTop: CGFloat { 16 }

    var marginBottom: CGFloat { 16 }

    func clean() {
        titleLabel.text = nil
    }
}
