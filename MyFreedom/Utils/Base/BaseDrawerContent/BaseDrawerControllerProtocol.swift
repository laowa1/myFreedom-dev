//
//  BaseDrawerControllerProtocol.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.03.2022.
//

import UIKit

protocol BaseDrawerContentViewControllerProtocol where Self: UIViewController {
    
    var contentViewHeight: CGFloat { get }
    var isDismissEnabled: Bool { get }
    var isAnimatedDismissEnabled: Bool { get }
    var isScrollEnabled: Bool { get }

    func dismissDrawer(completion: (() -> Void)?)
    func updateViewFrame()
}

extension BaseDrawerContentViewControllerProtocol {

    var isAnimatedDismissEnabled: Bool { true }

    var isDismissEnabled: Bool { true }

    var isScrollEnabled: Bool { true }

    func dismissDrawer(completion: (() -> Void)?) {
        guard let parent = parent as? BaseDrawerContainerViewController else { return }
        parent.dismissAction(completion)
    }

    func updateViewFrame() {
        guard let parent = parent as? BaseDrawerContainerViewController else { return }
        parent.updateViewFrame()
    }
}
