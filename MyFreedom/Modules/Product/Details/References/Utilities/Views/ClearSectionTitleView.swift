//
//  ClearSectionTitleView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class ClearSectionTitleView: UIView {

    var titleLabel: UILabel =  build {
        $0.textColor = BaseColor.base300
        $0.font = BaseFont.semibold.withSize(13)
        $0.text = "Сервис госуслуг временно недоступен"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClearSectionTitleView: CleanableView {
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 16) }

    func clean() {}
}

