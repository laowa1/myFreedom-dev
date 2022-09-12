//
//  UIStackView+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.03.2022.
//

import UIKit

fileprivate let shadowBgTag = 998

extension UIStackView {

    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UIStackView {
    
    func getContainerView(for view: UIView) -> UIView? {
        guard let superview = view.superview else { return nil }
        return superview == self ? view : getContainerView(for: superview)
    }
    
    func setHorizontalSpace(_ space: CGFloat) {
        let spaceView = UIView()
        self.addArrangedSubview(spaceView)
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.heightAnchor.constraint(equalToConstant: space).isActive = true
    }
    
    func addArrangedSubview(_ subview: UIView, insets: UIEdgeInsets) {
        if insets == .init() {
            addArrangedSubview(subview)
            return
        }
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(subview.getLayoutConstraints(over: self, insets: insets))
        addArrangedSubview(container)
    }
    
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        if subviews.contains(where: { $0.tag == shadowBgTag }) {
            return
        }
        let subView = UIView(frame: bounds)
        subView.tag = shadowBgTag
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

        subView.layer.cornerRadius = radiusSize
    }
    
    func addInvisibleView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.addArrangedSubview(view)
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach(addArrangedSubview(_:))
    }
}
