//
//  CDBonusBannerView.swift
//  MyFreedom
//
//  Created by m1pro on 01.06.2022.
//

import UIKit

class CDBonusBannerView: UIView {
    
    var imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 2
    }
    private lazy var titleVerticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(titleLabel, subtitleLabel)
    }
    let titleLabel: UILabel = build {
        $0.font = BaseFont.bold
        $0.textColor = BaseColor.base800
    }
    let subtitleLabel: UILabel = build {
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base700
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = 16
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.applyShadow()
    }
    
    private func configureSubviews() {
        backgroundColor = .clear
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(titleVerticalStack)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        titleVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleVerticalStack.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: 20),
            titleVerticalStack.leftAnchor.constraint(equalTo: leftAnchor),
            titleVerticalStack.rightAnchor.constraint(equalTo: rightAnchor),
            titleVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension CDBonusBannerView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 16, left: 16, bottom: 16, right: 16) }
    
    var containerBackgroundColor: UIColor { .white }
    
    func clean() { }
}
