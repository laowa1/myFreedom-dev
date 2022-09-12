//
//  ShimmerView.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit

class ShimmerView: UIView {

   let gradientLayer = CAGradientLayer()

   public override func layoutSubviews() {
       super.layoutSubviews()

       gradientLayer.frame = bounds
   }

   public override init(frame: CGRect) {
       super.init(frame: frame)

       addGradientLayer()
   }

   func addGradientLayer() {
       gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
       gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
       gradientLayer.colors = [
            BaseColor.base200.withAlphaComponent(0.9).cgColor,
            BaseColor.base200.withAlphaComponent(0.3).cgColor,
            BaseColor.base200.withAlphaComponent(0.9).cgColor
       ]
       gradientLayer.locations = [0.0, 0.5, 1.0]
       layer.addSublayer(gradientLayer)
   }

   func addAnimation() -> CABasicAnimation {
       let animation = CABasicAnimation(keyPath: "locations")
       animation.fromValue = [-1, -0.5, 0]
       animation.toValue = [1, 1.5, 2]
       animation.repeatCount = .infinity
       animation.duration = 0.9
       return animation
   }

   public func startAnimating() {
       let animation = addAnimation()

       gradientLayer.add(animation, forKey: animation.keyPath)
   }

   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ShimmerView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 3, left: 3, bottom: 3, right: 3) }
    
    func clean() { }
}
