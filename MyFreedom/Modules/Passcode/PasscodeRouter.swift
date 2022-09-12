//
//  PasscodeRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.04.2022.
//

import UIKit

protocol PasscodeRouterInput: AnyObject {
    
    func routeToBack()
    func login()
    func closeSession()
    func routeToReset(phone: String)
}

class PasscodeRouter {

    private weak var view: PasscodeViewInput?
    private unowned let commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> PasscodeViewInput {
        let viewController = PasscodeViewController()
        view = viewController
        
        let interactor = PasscodeInteractor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension PasscodeRouter: PasscodeRouterInput {
    
    func routeToBack() {
        view?.navigationController?.popToRootViewController(animated: true)
    }
    
    func login() {
        let vc = MainTabBarRouter(commonStore: commonStore).build()
        view?.present(NavigationController(rootViewController: vc), animated: true, completion: { [weak self] in
            self?.view?.navigationController?.popToRootViewController(animated: true)
        })
    }

    func closeSession() {
        view?.push(AuthorizationRouter(commonStore: commonStore, isHiddenBack: true).build(), removeCurrent: true, animated: true)
    }
    
    func routeToReset(phone: String) {
        let vc = AuthorizationRouter(commonStore: commonStore, phone: phone).build()
        view?.push(vc, animated: false)
    }
}
