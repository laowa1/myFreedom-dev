//
//  StoriesViewItem.swift
//  MyFreedom
//
//  Created by &&TairoV on 29.04.2022.
//

import UIKit

class HomeStoriesViewItem: UIView {

    var storyItem: UIView = build {
        $0.backgroundColor = .white
        $0.layer.borderColor = BaseColor.green500.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 16
    }

    var imageView: UIImageView = build {
        $0.layer.cornerRadius = 14
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setuplayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        storyItem.addSubview(imageView)
        addSubview(storyItem)
    }

    private func setuplayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(imageView.getLayoutConstraints(over: storyItem, left: 2, top: 2, right: 2, bottom: 2))

        storyItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(storyItem.getLayoutConstraints(over: self))
        NSLayoutConstraint.activate([storyItem.heightAnchor.constraint(equalToConstant: 92)])
    }
}

extension HomeStoriesViewItem: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 0, right: 0) }
    
    func clean() { }
}
