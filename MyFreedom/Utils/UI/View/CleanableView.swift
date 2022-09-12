//
//  CleanableView.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

protocol CleanableView: UIView {
    var contentInset: UIEdgeInsets { get }
    var containerBackgroundColor: UIColor { get }
    func clean()
}

extension CleanableView {
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }
    var containerBackgroundColor: UIColor { .clear }
}
