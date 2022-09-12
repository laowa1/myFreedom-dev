//
//  BaseTowInputView.swift.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.06.2022.
//

import UIKit

class BaseTwoInputView<T: Equatable>: UIView {

    let firstTextField: TPTitleTextFieldView<T> = build {
        $0.textField.font = BaseFont.regular.withSize(16)
    }

    let secondTextField: TPTitleTextFieldView<T> = build {
        $0.textField.font = BaseFont.regular.withSize(16)
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [firstTextField, secondTextField])) {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSubviews() {

        addSubview(stackView)

        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        firstTextField.set(height: 52)
        secondTextField.set(height: 52)
        layoutConstraints += stackView.getLayoutConstraints(over: self)

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension BaseTwoInputView: CleanableView {
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) }

    func clean() { }
}
