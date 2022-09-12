//
//  OfferViewItemCell.swift
//  MyFreedom
//
//  Created by m1pro on 01.06.2022.
//

import UIKit

class OfferViewItemCell: UICollectionViewCell {
    
    var imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
    }
    
    var titleLabel: UILabel = build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.medium.withSize(13)
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = 12
        
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
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
