//
//  BaseTabBarItem.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit

public class BaseTabBarItem: UIView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var icon: UIImage? {
        get { iconImageView.image }
        set {
            iconImageView.image = newValue?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                iconImageView.tintColor = BaseColor.green500
                titleLabel.textColor = BaseColor.green500
            } else {
                iconImageView.tintColor = BaseColor.base400
                titleLabel.textColor = BaseColor.base700
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setLayoutConstraints()
        stylize()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 13)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func stylize() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = BaseColor.base400
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = BaseColor.base700
        titleLabel.font = BaseFont.regular.withSize(12)
    }
}
