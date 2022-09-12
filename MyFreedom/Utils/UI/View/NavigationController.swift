//
//  NavigationController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.04.2022.
//

import UIKit

open class NavigationController: UINavigationController, BaseViewControllerProtocol {
    
    open var baseModalPresentationStyle: UIModalPresentationStyle { .fullScreen }
    
    open var baseModalTransitionStyle: UIModalTransitionStyle { modalTransitionStyle }

    open override var childForStatusBarStyle: UIViewController? { topViewController }

    public var topAlertView: UIView?

    public var popUpWindow: UIWindow?
    
    private var popRecognizer: InteractivePopRecognizer?

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = " "
        rootViewController.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        popRecognizer = InteractivePopRecognizer(navigationController: self)
        interactivePopGestureRecognizer?.delegate = popRecognizer
        modalPresentationCapturesStatusBarAppearance = true

        // Set back button style
        let backIndicatorImage = BaseImage.back.uiImage
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = BaseColor.base900
        UINavigationBar.appearance().backIndicatorImage = backIndicatorImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicatorImage

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: BaseColor.base900,
            .font: BaseFont.bold,
        ]
//        UINavigationBar.appearance().prefersLargeTitles = true
//        UINavigationBar.appearance().sizeToFit()
    }
    
    open override func present(
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
