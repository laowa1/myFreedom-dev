//
//  ExpensesViewItemCell.swift
//  MyFreedom
//
//  Created by &&TairoV on 4/30/22.
//

import UIKit

class ExpensesViewItemCell: UICollectionViewCell {

    private var containerView: UIView = build {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    var expensesItem = HomeExpensesWidget()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayout()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        containerView.addSubview(expensesItem)
        contentView.addSubview(containerView)
    }

    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(containerView.getLayoutConstraints(over: contentView, margin: 4))
        
        expensesItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(expensesItem.getLayoutConstraints(over: containerView, margin: 16))
    }
}
