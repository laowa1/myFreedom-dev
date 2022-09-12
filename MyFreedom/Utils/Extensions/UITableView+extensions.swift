//
//  UITableView+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseId)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseId)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseId)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.reuseId) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseId)")
        }
        return headerFooter
    }
    
    func reloadTableViewWithoutAnimation() {
        let contentOffset = contentOffset

        UIView.setAnimationsEnabled(false)
        beginUpdates()
        endUpdates()
        UIView.setAnimationsEnabled(true)

        layoutIfNeeded()
        self.contentOffset = contentOffset
    }
    
    func scrollToTop(animated: Bool = false) {
        DispatchQueue.main.async {
            self.setContentOffset(CGPoint.zero, animated: animated)
        }
    }
}
