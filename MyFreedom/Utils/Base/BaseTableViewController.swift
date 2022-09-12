//
//  BaseTableViewController.swift
//  MyFreedom
//
//  Created by m1 on 30.06.2022.
//

import UIKit

class BaseTableViewController: UITableViewController, BaseViewControllerProtocol, TableViewUpdatable {

    var baseModalPresentationStyle: UIModalPresentationStyle { .overFullScreen }

    var baseModalTransitionStyle: UIModalTransitionStyle { modalTransitionStyle }

    var topAlertView: UIView?

    var popUpWindow: UIWindow?

    private var customRefreshControl: RefreshControl?

    var refreshingIsAllowed = false {
        didSet {
            guard refreshingIsAllowed != oldValue else { return }
            if refreshingIsAllowed {
                customRefreshControl = RefreshControl()
                tableView.backgroundView = customRefreshControl
            } else {
                customRefreshControl = nil
                tableView.backgroundView = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.delegate = self
    }

    override func present(
        _ viewController: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let viewController = viewController as? BaseViewControllerProtocol {
            viewController.modalPresentationStyle = viewController.baseModalPresentationStyle
            viewController.modalTransitionStyle = viewController.baseModalTransitionStyle
        } else {
            viewController.modalPresentationStyle = baseModalPresentationStyle
            viewController.modalTransitionStyle = baseModalTransitionStyle
        }
        super.present(viewController, animated: flag, completion: completion)
    }
}

extension BaseTableViewController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if navigationController.isNavigationBarHidden {
            if navigationController.viewControllers.first != viewController {
                navigationController.setNavigationBarHidden(false, animated: animated)
            }
        } else {
            if navigationController.viewControllers.first == viewController {
                navigationController.setNavigationBarHidden(true, animated: animated)
            }
        }
    }
}
