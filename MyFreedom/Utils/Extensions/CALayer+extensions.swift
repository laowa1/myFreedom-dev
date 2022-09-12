//
//  CALayer.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.05,
        x: CGFloat = 0,
        y: CGFloat = 5,
        blur: CGFloat = 20,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
