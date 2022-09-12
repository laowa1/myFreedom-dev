//
//  CardRequisiteView.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import UIKit

class CardRequisiteView: UIView {

    var accessoryPressed: ((_ type: RequisiteClipboardType) -> Void)?

    private let requisiteName: PaddingLabel = build {
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base700
    }

    private let requisite: PaddingLabel = build {
        $0.font = BaseFont.semibold.withSize(16)
        $0.numberOfLines = 0
        $0.textColor = BaseColor.base800
    }

    private lazy var accessoryImage: UIImageView = build {
        $0.image = BaseImage.copy.uiImage
        $0.isUserInteractionEnabled = true
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [requisiteName, requisite])) {
        $0.axis = .vertical
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayout()

        accessoryImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessoryAction)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(stackView)
        addSubview(accessoryImage)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: accessoryImage.leadingAnchor, constant: -12)
        ]

        accessoryImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoryImage.heightAnchor.constraint(equalToConstant: 16),
            accessoryImage.widthAnchor.constraint(equalToConstant: 16)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func set(title: String?, subtitle: String?, icon: UIImage?) {
        requisiteName.text = title
        requisite.text = subtitle
        accessoryImage.image = icon
    }

    @objc private func accessoryAction() {
        UIPasteboard.general.string = requisite.text
        accessoryPressed?(.requisite)
    }
}

extension CardRequisiteView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) }

    func clean() { }
}
