//
//  CustomNavigation.swift
//  MyFreedom
//
//  Created by m1pro on 16.05.2022.
//

import UIKit

class CustomNavigation: UIView {

    private lazy var stackView: UIStackView = build {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
        $0.addArrangedSubviews(titleLabel, button)
    }
    let button: UIButton = build {
        $0.imageView?.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }
    let titleLabel = UILabel()
    let leftButton = UIButton(type: .system)
    let rightButton = UIButton(type: .system)

    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var image: BaseImage? {
        didSet {
            stackView.spacing = 4
            button.setImage(image?.uiImage, for: .normal)
        }
    }
    
    var leftButtonAction = {}
    var rightButtonAction = {}
    var leftButtonIcon: BaseImage? {
        didSet { leftButton.setImage(leftButtonIcon?.uiImage?.withRenderingMode(.alwaysOriginal), for: .normal) }
    }
    var leftButtonTitle: String? {
        didSet { leftButton.setTitle(leftButtonTitle, for: .normal) }
    }
    var rightButtonIcon: BaseImage? {
        didSet { rightButton.setImage(rightButtonIcon?.uiImage?.withRenderingMode(.alwaysOriginal), for: .normal) }
    }
    var rightButtonTitle: String? {
        didSet { rightButton.setTitle(rightButtonTitle, for: .normal) }
    }
    var titleColor: UIColor = BaseColor.base900 {
        didSet { titleLabel.textColor = titleColor }
    }
    var leftButtonInset: CGFloat = 16 {
        didSet {
            leftButtonConstraint.constant = abs(leftButtonInset)
        }
    }
    var rightButtonInset: CGFloat = 16 {
        didSet {
            rightButtonConstraint.constant = -abs(rightButtonInset)
        }
    }
    
    var rightButtonWidth: CGFloat = 40 {
        didSet {
            rightButtonWidthConstraint.constant = abs(rightButtonInset)
        }
    }
    
    var leftButtonWidth: CGFloat = 40 {
        didSet {
            leftButtonWidthConstraint.constant = abs(rightButtonInset)
        }
    }

    private lazy var leftButtonConstraint = leftButton.leftAnchor.constraint(
        equalTo: leftAnchor,
        constant: leftButtonInset
    )
    private lazy var rightButtonConstraint = rightButton.rightAnchor.constraint(
        equalTo: rightAnchor,
        constant: -rightButtonInset
    )
    
    private lazy var leftButtonWidthConstraint = leftButton.widthAnchor.constraint(greaterThanOrEqualToConstant: leftButtonWidth)
    private lazy var rightButtonWidthConstraint = rightButton.widthAnchor.constraint(greaterThanOrEqualToConstant: rightButtonWidth)

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        addSubview(stackView)
        addSubview(leftButton)
        addSubview(rightButton)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        leftButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            leftButtonConstraint,
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            leftButtonWidthConstraint,
            leftButton.heightAnchor.constraint(equalToConstant: 30)
        ]

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            rightButtonConstraint,
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            rightButtonWidthConstraint,
            rightButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ]

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftButton.rightAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
//            stackView.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)

        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        leftButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        rightButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    private func stylize() {
        backgroundColor = .clear
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        titleLabel.font = BaseFont.medium
    }

    private func setActions() {
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }

    @objc private func leftButtonTapped() {
        leftButtonAction()
    }

    @objc private func rightButtonTapped() {
        rightButtonAction()
    }
}
