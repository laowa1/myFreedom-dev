//
//  PDActionButtonView.swift
//  MyFreedom
//
//  Created by m1pro on 01.06.2022.
//

import UIKit

struct PDActionViewModel: Equatable {
    let title: String
    let image: BaseImage
}

class PDActionButtonView: UIView {
    
    var imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 2
    }
    let titleLabel: UILabel = build {
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base50
        $0.textAlignment = .center
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
        addSubview(titleLabel)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension PDActionButtonView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 22, left: 8, bottom: 22, right: 8) }
    
    var containerBackgroundColor: UIColor { BaseColor.base50.withAlphaComponent(0.15) }
    
    func clean() { }
}
