//
//  EmptyFooterView.swift
//  MyFreedom
//
//  Created by m1pro on 15.05.2022.
//

import UIKit

class EmptyFooterView: UIView, WrapperHeaderFooterContentView {

    var type: WrapperHeaderFooter { .footer }

    var marginTop: CGFloat { 0 }

    var marginBottom: CGFloat { 8 }

    func clean() { }
}
