//
//  TPSearchRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TPSearchRouter {
    
    private weak var view: TPSearchViewInput?
    private unowned let commonStore: CommonStore
    
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> TPSearchViewInput {
        let viewController = TPSearchViewController(style: .grouped)
        let interactor = TPSearchInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension TPSearchRouter: TPSearchRouterInput {

}
