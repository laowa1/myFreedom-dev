//
//  InteractivePopRecognizer.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.04.2022.
//

import UIKit

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {

    private unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return false
    }
}
