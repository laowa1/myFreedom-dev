//
//  SpinnerView.swift
//  MyFreedom
//
//  Created by Sanzhar on 12.04.2022.
//

import UIKit

final class SpinnerView: UIView {
    
    private static let lineWidth: CGFloat = 10
    
    private let bgLayer: CAShapeLayer = build {
        $0.fillColor = nil
        $0.lineWidth = SpinnerView.lineWidth
        $0.strokeColor = BaseColor.base50.cgColor
    }
    private let spinLayer: CAShapeLayer = build {
        $0.fillColor = nil
        $0.lineWidth = SpinnerView.lineWidth
        $0.strokeColor = BaseColor.green500.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(bgLayer)
        bgLayer.addSublayer(spinLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        [spinLayer, bgLayer].forEach {
            $0.frame = rect
            setPath(on: $0)
        }
    }
    
    private func setPath(on layer: CAShapeLayer) {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
    
    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.duration = duration
        animation.repeatCount = Float.infinity
        spinLayer.add(animation, forKey: animation.keyPath)
    }
    
    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }
}

extension SpinnerView {
    
    private struct Pose {
        
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    private class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }
}
