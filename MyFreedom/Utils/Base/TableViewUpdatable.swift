//
//  TableViewUpdatable.swift
//  MyFreedom
//
//  Created by m1 on 30.06.2022.
//

import UIKit

protocol TableViewUpdatable where Self: UIViewController {

    var tableView: UITableView! { get }
}

extension TableViewUpdatable {

    func reloadTableViewWithoutAnimation() {
        let contentOffset = tableView.contentOffset

        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)

        tableView.layoutIfNeeded()
        tableView.contentOffset = contentOffset
    }
}
