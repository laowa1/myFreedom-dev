//
//  PDLimitsRouter.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import Foundation

class PDLimitsRouter {
    
    private var view: PDLimitsViewInput?
    private unowned let commonStore: CommonStore
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> PDLimitsViewInput {
        let viewController = PDLimitsViewContoller()
        let interactor = PDLimitsInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension PDLimitsRouter: PDLimitsRouterInput {
    
    func presentDetail() {
        let vc = LimitDetailRouter(commonStore: commonStore).build()
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
}
