//
//  JCLRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import Foundation

class JCLRouter {
    
    private var view: JCLViewInput?
    private unowned let commonStore: CommonStore
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> JCLViewInput {
        let viewController = JCLViewController()
        let interactor = JCLInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension JCLRouter: JCLRouterInput {
    func presentDetail() {
        let vc = JCLDetailRouter(commonStore: commonStore).build()
        view?.present(vc, animated: true)
    }
    
    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol) {
        view?.presentBottomDrawerViewController(with: module)
    }
    
    func popViewContoller() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func closeSession() {
        view?.dismiss(animated: false)
    }
    
    func routeToBlockedPayments() {
        let vc = JCLBPLRouter(commonStore: commonStore).build()
        view?.push(vc)
    }
}
