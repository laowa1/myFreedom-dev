//
//  TPRecentRequestsView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

class TPRecentRequestsView: UIView {

    let itemIcon: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    var itemTitle: UILabel = build {
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.medium.withSize(13)
        $0.numberOfLines = 2
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [itemIcon, itemTitle])) {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 12
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, safe: false)
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 20)]

        itemIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            itemIcon.heightAnchor.constraint(equalToConstant: 20),
            itemIcon.widthAnchor.constraint(equalToConstant: 20)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension TPRecentRequestsView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) }
    
    func clean() {

    }
}
