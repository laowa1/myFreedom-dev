//
//  ButtonFooterView.swift
//  MyFreedom
//
//  Created by m1pro on 16.06.2022.
//

import UIKit

class ButtonFooterView: UIView {

    let button = ButtonFactory().getGreenButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureSubviews() {
        addSubview(button)
        
        var layoutConstraints = [NSLayoutConstraint]()

        button.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += button.getLayoutConstraints(over: self, left: 16, top: 11, right: 16, bottom: 11)
        layoutConstraints += [button.heightAnchor.constraint(equalToConstant: 52)]

        NSLayoutConstraint.activate(layoutConstraints)
    }
}
