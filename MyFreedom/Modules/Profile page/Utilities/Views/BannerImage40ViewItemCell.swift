//
//  BannerImage40ViewItemCell.swift
//  MyFreedom
//
//  Created by m1pro on 16.05.2022.
//

import UIKit

class BannerImage40ViewItemCell: UICollectionViewCell {
    
    var imageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
    }
    
    var closeButton: UIButton = build {
        $0.contentMode = .scaleAspectFit
        $0.setImage(BaseImage.roundClose.uiImage, for: .normal)
        $0.isHidden = true
    }
    
    var titleLabel: UILabel = build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.medium.withSize(13)
        $0.adjustsFontSizeToFitWidth = true
        $0.lineBreakMode = .byClipping
        $0.minimumScaleFactor = 0.9
        $0.numberOfLines = 2
    }

    private lazy var imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 40)
    
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
        layer.applyShadow(alpha: 0.03)
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
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageWidthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            closeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 18),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }

    func set(height: CGFloat) {
        imageWidthConstraint.constant = height
        imageView.layoutIfNeeded()
    }
}
