//
//  HomeButtonView.swift
//  MyFreedom
//
//  Created by &&TairoV on 29.04.2022.
//

import UIKit

protocol PrimaryButtonViewDelegate: AnyObject {
    func didSelectButton()
}

class PrimaryButtonView<ID: Equatable>: UIView {
    
    lazy var button: BaseButton = build(ButtonFactory().getTextButton()) {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = BaseFont.semibold.withSize(18)
    }

    var isEnabled: Bool = true {
        didSet {
            button.isUserInteractionEnabled = isEnabled
        }
    }
    var indexPath: ID?
    weak var delegate: PrimaryButtonViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        addSubview(button)
    }

    private func setLayoutConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false

        var layoutConstraints = button.getLayoutConstraints(over: self)
        layoutConstraints += [button.heightAnchor.constraint(equalToConstant: 52)]
        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func buttonTapped() {
        delegate?.didSelectButton()
    }
}

extension PrimaryButtonView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 16) }
    
    func clean() { }
}
