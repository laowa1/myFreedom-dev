//
//  MainTabBarViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UINavigationController

class MainTabBarViewController: BaseTabBarController {

    var interactor: MainTabBarInteractorInput?
    var router: MainTabBarRouterInput?
    
    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

extension MainTabBarViewController: MainTabBarViewInput {

}
