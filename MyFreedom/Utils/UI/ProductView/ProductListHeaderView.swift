//
//  ProductListHeaderView.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.05.2022.
//

import UIKit

class ProductListHeaderView: UIView {
    
    var rightButtonAction = {}
    
    lazy var button: UIButton = build {
        $0.setTitleColor(BaseColor.green500, for: .normal)
        $0.titleLabel?.font = BaseFont.semibold.withSize(14)
        $0.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    var isExpand: Bool = false {
        didSet {
            isExpand ? button.rotate(degrees: 180) : button.identity()
        }
    }
    
    private let titleLabel: UILabel = build {
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base700
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(button)
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: button.leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        button.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 16),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 16)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    @objc private func rightButtonTapped() {
        rightButtonAction()
    }
    
    func set(text: String?) {
        titleLabel.text = text
    }
}

extension ProductListHeaderView: WrapperHeaderFooterContentView {

    var type: WrapperHeaderFooter { .header }

    var marginTop: CGFloat { 16 }

    var marginBottom: CGFloat { 0 }

    func clean() {
        titleLabel.text = nil
    }
}
