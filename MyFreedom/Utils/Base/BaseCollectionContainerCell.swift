//
//  BaseCollectionContainerCell.swift
//  MyFreedom
//
//  Created by m1pro on 21.05.2022.
//

import UIKit

final class BaseCollectionContainerCell<T: CleanableView>: UICollectionViewCell {
    
    let innerView = T()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        innerView.clean()
    }
    
    private func addSubviews() {
        backgroundColor = innerView.containerBackgroundColor
        contentView.addSubview(innerView)
        
        var layoutConstraints = [NSLayoutConstraint]()
    
        innerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += innerView.getLayoutConstraints(over: contentView, insets: innerView.contentInset)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func addCorner(radius: CGFloat = 12) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
