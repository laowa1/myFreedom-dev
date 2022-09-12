//
//  BaseTabBar.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit

class BaseTabBar: UIView {
    
    private let topLine = UIView()
    private let stackView = UIStackView()
    
    public var items = [BaseTabBarItem]() {
        didSet {
            oldValue.forEach { item in
                self.stackView.removeArrangedSubview(item)
                NSLayoutConstraint.deactivate(item.constraints)
                item.removeFromSuperview()
            }
            
            items.forEach(stackView.addArrangedSubview)
            items.first?.isSelected = true
            setNeedsUpdateConstraints()
        }
    }
    
    var itemTapHandler: (_ itemIndex: Int) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addSubviews() {
        addSubview(topLine)
        addSubview(stackView)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            topLine.leftAnchor.constraint(equalTo: leftAnchor),
            topLine.topAnchor.constraint(equalTo: topAnchor),
            topLine.rightAnchor.constraint(equalTo: rightAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func stylize() {
        backgroundColor = .clear
        
        topLine.backgroundColor = BaseColor.base500.withAlphaComponent(0.1)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    private func setActions() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let tabBar = sender.view, tabBar == self else { return }
        
        let location = sender.location(in: tabBar)
        guard let selectedItem = tabBar.hitTest(location, with: nil) as? BaseTabBarItem else { return }
        
        for (index, item) in items.enumerated() {
            if item == selectedItem {
                itemTapHandler(index)
                item.isSelected = true
            } else {
                item.isSelected = false
            }
        }
    }
}
