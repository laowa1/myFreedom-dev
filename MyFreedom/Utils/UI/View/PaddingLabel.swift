//
//  PaddingLabel.swift
//  MyFreedom
//
//  Created by m1pro on 08.04.2022.
//

import UIKit.UILabel

class PaddingLabel: UILabel {

    private var topInset: CGFloat = 0.0
    private var bottomInset: CGFloat = 0.0
    private var leftInset: CGFloat = 0.0
    private var rightInset: CGFloat = 0.0

    var insets: UIEdgeInsets = .zero {
        didSet {
            topInset = insets.top
            bottomInset = insets.bottom
            leftInset = insets.left
            rightInset = insets.right
        }
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
