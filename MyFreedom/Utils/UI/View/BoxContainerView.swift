//
//  BoxContainerView.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

class BoxContainerView: UIView {
    
    private lazy var backgroundView: UIVisualEffectView = build(.init(effect: UIBlurEffect(style: .light))) {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.alpha = 0.8
    }
    
    lazy var stack: UIStackView = build(.init(arrangedSubviews: contentViews)) {
        $0.spacing = 0
        $0.alignment = .fill
        $0.axis = .vertical
    }
    
    private let contentViews: [UIView]
    
    required init(contentViews: [UIView]) {
        self.contentViews = contentViews
        super.init(frame: .zero)
        setups()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 5, blur: 20, spread: 0)
    }

    private func setups() {
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = .white.withAlphaComponent(0.8)
        addSubview(backgroundView)
        addSubview(stack)
        
        setLayoutConstraints()
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += backgroundView.getLayoutConstraints(over: self, safe: true)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stack.getLayoutConstraints(over: self, safe: true)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
        stack.backgroundColor = color
    }
}
