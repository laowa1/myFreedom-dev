//
//  BaseContainerCell.swift
//  MyFreedom
//
//  Created by m1pro on 03.05.2022.
//

import UIKit

final class BaseContainerCell<T: CleanableView>: UITableViewCell {
    
    let innerView = T()
    private let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
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
        layoutConstraints += innerView.getLayoutConstraints(over: contentView, safe: false, insets: innerView.contentInset)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func removeLine() {
        separatorInset.left = UIScreen.main.bounds.width
    }
}
