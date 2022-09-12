//
//  BaseLayoutConstraintProtocol.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

public protocol BaseLayoutConstraintProtocol where Self: UIView { }

public extension BaseLayoutConstraintProtocol {
    
    func layout(over view: UIView, safe: Bool = true, margin: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = getLayoutConstraints(over: view, safe: safe, margin: margin)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func layout(
        over view: UIView,
        safe: Bool = true,
        left: CGFloat = 0,
        top: CGFloat = 0,
        right: CGFloat = 0,
        bottom: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = getLayoutConstraints(
            over: view,
            safe: safe,
            left: left,
            top: top,
            right: right,
            bottom: bottom
        )
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func layoutByCentering(over view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = getLayoutConstraintsByCentering(over: view)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func getLayoutConstraints(over view: UIView, safe: Bool = true, margin: CGFloat) -> [NSLayoutConstraint] {
        return getLayoutConstraints(over: view, safe: safe, left: margin, top: margin, right: margin, bottom: margin)
    }
    
    func getLayoutConstraints(over view: UIView, safe: Bool = true, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        return getLayoutConstraints(over: view, safe: safe, left: insets.left, top: insets.top, right: insets.right, bottom: insets.bottom)
    }
    
    func getLayoutConstraints(
        over view: UIView,
        safe: Bool = true,
        left: CGFloat = 0,
        top: CGFloat = 0,
        right: CGFloat = 0,
        bottom: CGFloat = 0
    ) -> [NSLayoutConstraint] {

        let viewTopAnchor = safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        let viewBottomAnchor = safe ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor

        return [
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left),
            topAnchor.constraint(equalTo: viewTopAnchor, constant: top),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -abs(right)),
            bottomAnchor.constraint(equalTo: viewBottomAnchor, constant: -abs(bottom))
        ]
    }
    
    func getLayoutConstraintsByCentering(over view: UIView) -> [NSLayoutConstraint] {
        return [
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }
}
