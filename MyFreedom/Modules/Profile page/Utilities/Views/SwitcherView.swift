//
//  SwitcherView.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import UIKit

protocol SwitchFieldViewDelegate: AnyObject {
    func switcher<ID>(isOn: Bool, forId id: ID)
}

class SwitcherView<Identifier: Equatable>: UIView {

    let iconView = UIImageView()
    let titleLabel = UILabel()
    let subitleLabel = UILabel()
    let switcher = UISwitch()
    
    var id: Identifier?
    weak var delegate: SwitchFieldViewDelegate?
    
    var isOn: Bool {
        get { switcher.isOn }
        set { switcher.isOn = newValue }
    }

    var isEnabled: Bool {
        get { switcher.isEnabled }
        set {
            switcher.alpha = newValue ? 1 : 0.5
            switcher.isEnabled = newValue
        }
    }

    private lazy var mainStackView: UIStackView = build(UIStackView(arrangedSubviews: [iconView,infoStackView, switcher])) {
        $0.spacing = 12
        $0.alignment = .center
        $0.axis = .horizontal
    }

    private lazy var infoStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subitleLabel])) {
        $0.axis = .vertical
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubviews()
        setupLayout()
        stylize()
        switcher.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(mainStackView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconView.heightAnchor.constraint(equalToConstant: 32),
            iconView.widthAnchor.constraint(equalToConstant: 32)
        ]

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += mainStackView.getLayoutConstraints(over: self, safe: false)
        layoutConstraints += [mainStackView.heightAnchor.constraint(equalToConstant: 54)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        titleLabel.font = BaseFont.medium.withSize(16)
        titleLabel.textColor = .black

        subitleLabel.font = BaseFont.regular.withSize(13)
        subitleLabel.textColor = BaseColor.base700
        subitleLabel.textAlignment = .left
        subitleLabel.numberOfLines = 2
    }
    
    @objc private func valueChanged(sender: UISwitch?) {
        guard let switcher = sender else { return }
        if let delegate = delegate, let id = id, self.switcher == switcher {
            delegate.switcher(isOn: switcher.isOn, forId: id)
        }
    }
}

extension SwitcherView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 4, left: 16, bottom: 4, right: 16) }

    func clean() {
        switcher.alpha = 1
    }
}
