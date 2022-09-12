//
//  RemunerationForEntirePeriodView.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import UIKit

class RemunerationForEntirePeriodView: UIView {
    
    private let gradientLayer: CAGradientLayer = build {
        $0.colors = [BaseColor.indigo300.cgColor, BaseColor._4CD964.cgColor]
        $0.locations = [0, 1]
        $0.startPoint = CGPoint(x: 0, y: 1)
        $0.endPoint = CGPoint(x: 1, y: 1)
        $0.cornerRadius = 16
    }
    private lazy var gradientView: UIView = build {
        $0.layer.insertSublayer(gradientLayer, at: 0)
        $0.addSubview(percentLabel)
    }
    let percentLabel: UILabel = build {
        $0.font = BaseFont.bold.withSize(18)
        $0.textColor = BaseColor.base50
        $0.textAlignment = .center
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
        $0.font = BaseFont.medium.withSize(11)
        $0.textColor = BaseColor.base700
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        gradientLayer.frame = gradientView.bounds
    }
    
    private func configureSubviews() {
        backgroundColor = BaseColor.base50
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        addSubview(titleVerticalStack)
        addSubview(gradientView)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        titleVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleVerticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleVerticalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ]
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            gradientView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gradientView.leftAnchor.constraint(equalTo: titleVerticalStack.rightAnchor, constant: 8),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            gradientView.widthAnchor.constraint(equalToConstant: 67),
            gradientView.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += percentLabel.getLayoutConstraints(over: gradientView)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension RemunerationForEntirePeriodView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 8, left: 16, bottom: 8, right: 16) }
    
    var containerBackgroundColor: UIColor { BaseColor.base100 }
    
    func clean() { }
}
