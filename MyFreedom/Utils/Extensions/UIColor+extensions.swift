//
//  UIColor+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit.UIColor

extension UIColor {

    convenience init(rgb: UInt8..., alpha: UInt = 100) {
        self.init(
            red: CGFloat(rgb[0]) / 255,
            green: CGFloat(rgb[1]) / 255,
            blue: CGFloat(rgb[2]) / 255,
            alpha: CGFloat(min(alpha, 100)) / 100
        )
    }

    convenience init?(hex: String) {
        guard hex.hasPrefix("#") else { return nil }

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        guard hexColor.count == 6 else { return nil }

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }

        let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        let b = CGFloat((hexNumber & 0x0000ff)) / 255

        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
