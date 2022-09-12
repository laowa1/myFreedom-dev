//
//  BaseViewControllerProtocol.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit
import SafariServices
import Lottie

protocol BaseViewControllerProtocol where Self: UIViewController {
    
    var baseModalPresentationStyle: UIModalPresentationStyle { get }
    
    var baseModalTransitionStyle: UIModalTransitionStyle { get }
    
    var topAlertView: UIView? { get set }

    var popUpWindow: UIWindow? { get set }
}

extension BaseViewControllerProtocol {
    
    var statusBarFrame: CGRect? { UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame }

    var viewSize: CGSize? { UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size }
    
    var topmostViewController: UIViewController { getTopmostViewControllerInChain(containing: self) }

    var isLoading: Bool { topmostViewController is LoaderViewController }

    func showAlertOnTop(withMessage message: String, lottie: BaseLottie? = .toastWarning) {
        if let topAlertView = topAlertView {
            topAlertView.layer.removeAllAnimations()
            topAlertView.removeFromSuperview()
        }

        let view: UIView
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            view = topController.view
        } else {
            view = self.view
        }

        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let height = CGFloat(40)
        let space = CGFloat(25)
        let totalHeight = statusBarHeight + space + height
        
        let containerView = UIView(frame: CGRect(x: 0, y: -totalHeight, width: view.frame.width, height: totalHeight))
        view.addSubview(containerView)
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 16, y: statusBarHeight + space, width: view.frame.width - 32, height: height)
        contentView.backgroundColor = .clear
        containerView.addSubview(contentView)
        
        let animationView = AnimationView()
        let iconSize = CGSize(width: 24, height: 24)
        animationView.loopMode = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = lottie?.animation
        animationView.bounds.size = iconSize
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 2
        messageLabel.textColor = BaseColor.base900
        messageLabel.font = BaseFont.semibold.withSize(14)
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.8
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stackView = BoxContainerView(contentViews: [animationView, messageLabel])
        stackView.stack.axis = .horizontal
        stackView.stack.distribution = .fill
        stackView.stack.alignment = .center
        stackView.stack.spacing = 8
        stackView.stack.layoutMargins = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        stackView.stack.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            containerView.frame.origin.y = 0
        }) { completed in
            UIView.animate(withDuration: 0.25, delay: 1.5, options: .curveEaseIn, animations: {
                containerView.frame.origin.y = -totalHeight
            }) { completed in
                containerView.removeFromSuperview()
            }
        }
        topAlertView = containerView
        
        animationView.play()
    }
    
    func getTopmostViewControllerInChain(containing viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return getTopmostViewControllerInChain(containing: presentedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return getTopmostViewControllerInChain(containing: visibleViewController)
            }
        } else if let tabBarController = viewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return getTopmostViewControllerInChain(containing: selected)
            }
        }
        
        return viewController
    }
    
    func showLoader() {
        let loaderViewController = LoaderViewController()
        presentOnNewWindow(loaderViewController)
    }
    
    func hideLoader() {
        dismissWithNewWindow(LoaderViewController.self)
    }
    
    
    func push(_ viewController: UIViewController, removeCurrent: Bool = false, animated: Bool = true) {
        defer {
            if removeCurrent,
               let controllers = navigationController?.viewControllers,
               let index = controllers.firstIndex(where: { $0 === self }) {
                navigationController?.viewControllers.remove(at: index)
            }
        }

        // Remove title from backBarButtonItem
        if let navigationController = self as? UINavigationController,
           let baseViewController = navigationController.visibleViewController as? BaseViewControllerProtocol {
            baseViewController.push(viewController, animated: animated)
            return
        }

        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = " "
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func push(_ viewController: UIViewController, removeControllersWithIndices indices: [Int], animated: Bool = true) {
        defer {
            if let navigationController = navigationController {
                var controllers = navigationController.viewControllers
                let filteredIndices: [Int] = Array(Set(indices)).sorted().reversed()
                for index in filteredIndices where 0..<controllers.count ~= index {
                    controllers.remove(at: index)
                }
                navigationController.setViewControllers(controllers, animated: false)
            }
        }
        
        if let navigationController = self as? UINavigationController,
           let baseViewController = navigationController.visibleViewController as? BaseViewControllerProtocol {
            baseViewController.push(viewController, animated: animated)
            return
        }

        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = " "
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func presentWebPage(with url: URL) {
        let sfSafariViewController = SFSafariViewController(url: url)
        present(sfSafariViewController, animated: true)
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    internal func presentOnNewWindow(_ viewController: BaseViewController) {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        let backgroundViewController = BaseViewController()
        backgroundViewController.view.backgroundColor = .clear
        newWindow.rootViewController = backgroundViewController
        newWindow.windowLevel = UIWindow.Level.alert + 1
        newWindow.makeKeyAndVisible()
        backgroundViewController.present(viewController, animated: true)
        popUpWindow = newWindow
    }

    internal func dismissWithNewWindow<T: BaseViewController>(
        _: T.Type,
        animated: Bool = true,
        completion: @escaping () -> Void = {}
    ) {
        guard let window = popUpWindow,
              let presentedViewController = window.rootViewController?.presentedViewController as? T else {
            completion()
            return
        }

        presentedViewController.dismiss(animated: animated) { [weak self] in
            if let self = self {
                self.popUpWindow?.isHidden = true
                self.popUpWindow = nil
            }
            completion()
        }
    }
}
