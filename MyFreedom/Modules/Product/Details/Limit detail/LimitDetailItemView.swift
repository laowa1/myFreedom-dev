//
//  LimitDetailItemView.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import UIKit

class LimitDetailItemView: UIView {
    
    private lazy var titleVerticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(titleLabel, subtitleLabel)
    }
    let titleLabel: UILabel = build {
        $0.font = BaseFont.semibold.withSize(18)
        $0.textColor = BaseColor.base800
        $0.textAlignment = .center
    }
    let subtitleLabel: UILabel = build {
        $0.font = BaseFont.medium.withSize(14)
        $0.textColor = BaseColor.base700
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
        addSubview(titleVerticalStack)
        titleVerticalStack.layout(over: self)
    }
}

extension LimitDetailItemView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 11, left: 4, bottom: 11, right: 4) }
    
    var containerBackgroundColor: UIColor { BaseColor.base50 }
    
    func clean() { }
}
