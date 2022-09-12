//
//  WrapperHeaderFooterContentView.swift
//  MyFreedom
//
//  Created by m1pro on 05.05.2022.
//

import UIKit

protocol WrapperHeaderFooterContentView: CleanableView {

    var type: WrapperHeaderFooter { get }
    var marginTop: CGFloat { get }
    var marginBottom: CGFloat { get }
}

enum WrapperHeaderFooter {

    case header, footer

    var corners: UIRectCorner {
        switch self {
        case .header: return [.topLeft, .topRight]
        case .footer: return [.bottomLeft, .bottomRight]
        }
    }
}
