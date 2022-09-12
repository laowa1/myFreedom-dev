//
//  SuffixTextField.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import UIKit.UITextField

class SuffixTextField: UITextField {

    private let suffixLabel = UILabel()

    private let suffixSpace: CGFloat = 20
    private var suffixLabelLeftConstraint: NSLayoutConstraint?

    var suffix: String? {
        get { suffixLabel.text }
        set { suffixLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(suffixLabel)
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        if let textRange = allTextRange {
            let textRect = firstRect(for: textRange)
            let textRectX = textRect.origin.x
            if textRectX != .infinity && textRectX != -.infinity {
                suffixLabelLeftConstraint?.constant = textRect.width + textRectX + suffixSpace
            }
            suffixLabel.isHidden = text?.isEmpty != false
        }

        super.draw(rect)
    }

    private func setLayoutConstraints() {
        let suffixLabelLeftConstraint = suffixLabel.leftAnchor.constraint(equalTo: leftAnchor)
        self.suffixLabelLeftConstraint = suffixLabelLeftConstraint

        suffixLabel.translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = [
            suffixLabelLeftConstraint,
            suffixLabel.topAnchor.constraint(equalTo: topAnchor),
            suffixLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            suffixLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        suffixLabel.isHidden = true
        suffixLabel.textColor = BaseColor.base900
        suffixLabel.font = BaseFont.medium
    }
}
