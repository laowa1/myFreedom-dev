//
//  GrowPresentAnimationController.swift
//  MyFreedom
//
//  Created by m1pro on 14.05.2022.
//

import UIKit

final class GrowPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect

    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.4 }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)

        toViewController.view.frame = self.originFrame
        toViewController.view.alpha = 0

        containerView.addSubview(toViewController.view)

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
        animations: {
            toViewController.view.frame = finalFrame
            toViewController.view.layoutIfNeeded()
            toViewController.view.alpha = 1
        }, completion: { _ in
            toViewController.view.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

