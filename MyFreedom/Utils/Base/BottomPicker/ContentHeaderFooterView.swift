//
//  ContainerView.swift
//  MyFreedom
//
//  Created by &&TairoV on 11.04.2022.
//

import UIKit

class ContentHeaderFooterView<T: CleanableView>: UITableViewHeaderFooterView {

    let innerView = T()

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let view = UIView()
        view.backgroundColor = .clear

        backgroundView = view
        contentView.addSubview(innerView)

        innerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(innerView.getLayoutConstraints(over: contentView, insets: innerView.contentInset))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        innerView.clean()
    }
}

class CollectionHeaderFooterView<T: CleanableView>: UICollectionReusableView {

    let innerView = T()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        addSubview(innerView)

        innerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(innerView.getLayoutConstraints(over: self, insets: innerView.contentInset))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        innerView.clean()
    }
}
