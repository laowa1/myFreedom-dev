//
//  InitialRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

protocol InitialRouterInput: AnyObject {
    func routeToAuthView()
}

class InitialRouter {

    private unowned let commonStore: CommonStore
    private unowned let window: UIWindow

    init(commonStore: CommonStore, window: UIWindow) {
        self.commonStore = commonStore
        self.window = window
    }

    func build() -> InitialViewInput {
        let viewController = InitialViewController()

        let jailbreakDetection = JailbreakDetection()
        let interactor = InitialInteractor(
            view: viewController,
            jailbreakDetectionService: jailbreakDetection
        )
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    } 
}

extension InitialRouter: InitialRouterInput {

    func routeToAuthView() {
        guard let initialView = window.rootViewController?.view else {
            fatalError("window.rootViewController?.view is nil")
        }

        let viewController: UIViewController
        if let _: Bool = KeyValueStore().getValue(for: .usePasscodeToUnlock) {
            viewController = PasscodeRouter(commonStore: commonStore).build()
        } else {
            viewController = StoriesRouter(commonStore: commonStore, delegate: self).build()
        }
        let navigationController = NavigationController(rootViewController: viewController)
        window.rootViewController = navigationController

        UIView.transition(
            with: window,
            duration: 0.7,
            options: .transitionCrossDissolve,
            animations: { initialView.removeFromSuperview() }
        )
    }
}

extension InitialRouter: StoriesDelegate {
    
    var showNextButton: Bool { true }
    var showCloseButton: Bool { false }
    var routeToAuth: Bool { true }

    func nextButtonAction() { }
}
