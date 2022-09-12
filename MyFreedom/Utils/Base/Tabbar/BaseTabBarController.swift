//
//  BaseTabBarController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit

class BaseTabBarController: UITabBarController, BaseViewControllerProtocol, UINavigationControllerDelegate {
    
    var baseModalPresentationStyle: UIModalPresentationStyle { .overFullScreen }
    
    var baseModalTransitionStyle: UIModalTransitionStyle { modalTransitionStyle }

    override var childForStatusBarStyle: UIViewController? { children.first }
    
    var topAlertView: UIView?

        var popUpWindow: UIWindow?
    
    private let barBackgroundView = UIView()
    
    private let baseTabBar = BaseTabBar()

    override var selectedIndex: Int {
        didSet {
            for (index, item) in baseTabBar.items.enumerated() {
                item.isSelected = index == selectedIndex
            }
        }
    }

    override var viewControllers: [UIViewController]? {
        didSet {
            guard let viewControllers = viewControllers else { return }
            baseTabBar.items = viewControllers.compactMap {
                if let nav = $0 as? UINavigationController {
                    return (nav.topViewController as? BaseTabBarPresentable)?.baseTabBarItem
                }
                return ($0 as? BaseTabBarPresentable)?.baseTabBarItem
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(barBackgroundView)
        barBackgroundView.addSubview(baseTabBar)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        barBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            barBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            barBackgroundView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            barBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            barBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        baseTabBar.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            baseTabBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            baseTabBar.topAnchor.constraint(equalTo: barBackgroundView.topAnchor),
            baseTabBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            baseTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        view.layoutIfNeeded()
    }
    
    private func stylize() {
        barBackgroundView.backgroundColor = .clear
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = .clear
        UITabBar.appearance().tintColor = .clear
        tabBar.isUserInteractionEnabled = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .selected)
        
        // add blur
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurEffectView, at: 0)
    }
    
    private func setActions() {
        baseTabBar.itemTapHandler = { [weak self] itemIndex in
            guard let tabBarController = self, itemIndex != tabBarController.selectedIndex else { return }
            
            if let selectedViewController = tabBarController.selectedViewController,
               let selectingViewController = tabBarController.viewControllers?[itemIndex] {
                UIView.transition(
                    from: selectedViewController.view,
                    to: selectingViewController.view,
                    duration: 0.25,
                    options: [.transitionCrossDissolve, .curveEaseOut]
                )
            }
            
            tabBarController.selectedIndex = itemIndex
        }
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
