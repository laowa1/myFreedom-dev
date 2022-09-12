//
//  InfoTextView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class InfoTextView: UIView {

    let textView: UITextView = build {
        $0.backgroundColor = .clear
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base700
        $0.textContainerInset = .zero
        $0.isEditable = false
        $0.isScrollEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {

        addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate(textView.getLayoutConstraints(over: self))
    }
}

extension InfoTextView: CleanableView {
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16) }

    func clean() {}
}
