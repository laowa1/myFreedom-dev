//
//  BaseInputView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class TPTitleTextFieldView<T: Equatable>: TPTextFieldView<T> {

    let titleLabel: PaddingLabel = build {
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base700
        $0.isHidden = true
    }

    var title: String {
        get { titleLabel.text ?? "" }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = false
        }
    }

    override func configureSubviews() {
        set(height: 52)

        stackView.insertArrangedSubview(titleLabel, at: 0)
        stackView.spacing = 12
    }

    override var contentInset: UIEdgeInsets { UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) }

    override func clean() {
        stackView.spacing = 12
    }
}
