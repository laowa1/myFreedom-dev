//
//  MainTabBarRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import Foundation
import UIKit

class MainTabBarRouter {

    private unowned let commonStore: CommonStore
    private weak var view: MainTabBarViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> MainTabBarViewInput {
        let viewController = MainTabBarViewController()
        view = viewController

        let interactor = MainTabBarInteractor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        let homeRouter = HomeRouter(commonStore: commonStore)

        let transfersPaymentsRouter = TPRouter(commonStore: commonStore)
        
        let serviceRouter = ServiceViewController()
        let charRouter = ChatViewContoller()
        let more = MoreViewContoller()
        
        viewController.viewControllers = [
            homeRouter.build(),
            UINavigationController(rootViewController: transfersPaymentsRouter.build()),
            serviceRouter,
            charRouter,
            more
        ]

        return viewController
    }
}

extension MainTabBarRouter: MainTabBarRouterInput { }
