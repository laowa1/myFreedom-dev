//
//  EmptyHeaderView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class EmptyHeaderView: UIView, WrapperHeaderFooterContentView {
    
    var type: WrapperHeaderFooter { .header }

    var marginTop: CGFloat { 8 }

    var marginBottom: CGFloat { 0 }

    func clean() { }
}
