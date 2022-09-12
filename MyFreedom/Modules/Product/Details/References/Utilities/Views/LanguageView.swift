//
//  LanguageView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class LanguageView: UIView {

    let titleLabel: UILabel =  build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.medium
        $0.text = "Сервис госуслуг временно недоступен"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubview(titleLabel)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += titleLabel.getLayoutConstraints(over: self, left: 0, top: 11, right: 0, bottom: 11)
        layoutConstraints += [titleLabel.heightAnchor.constraint(equalToConstant: 22)]

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension LanguageView: WACleanableView {
    
    var label: UILabel { titleLabel } 
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 12) }

    func clean() {}
}
