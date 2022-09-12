//
//  UIViewController+extensions.swift
//  MyFreedom
//
//  Created by &&TairoV on 18.03.2022.
//

import UIKit

extension UIViewController {

    var statusBarFrame: CGRect? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }

    func presentBottomDrawerViewController(
        with contentViewController: BaseDrawerContentViewControllerProtocol,
        completion: (() -> Void)? = nil
    ) {
        let viewController = BaseDrawerContainerViewController(contentViewController: contentViewController)
        present(viewController, animated: false, completion: completion)
    }
}

extension UIViewController { }
