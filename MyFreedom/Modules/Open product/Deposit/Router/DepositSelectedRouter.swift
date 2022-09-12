//
//  DepositSelectedRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class DepositSelectedRouter {
    
    private weak var view: DepositSelectedViewInput?
    private unowned let commonStore: CommonStore
    
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> DepositSelectedViewInput {
        let viewController = DepositSelectedViewController()
        let interactor = DepositSelectedInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension DepositSelectedRouter: DepositSelectedRouterInput {

}
