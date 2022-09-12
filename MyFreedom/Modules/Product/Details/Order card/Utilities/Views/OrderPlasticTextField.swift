//
//  OrderPlasticTextField.swift
//  MyFreedom
//
//  Created by Bend3r on 7/22/22.
//  Copyright © 2022 bankffin.kz. All rights reserved.
//

import UIKit

class OrderPlasticTextField<T: Equatable>: TPTextFieldView<T>  {
    
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

    override var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16) }

    override func clean() {
        stackView.spacing = 12
    }


}
