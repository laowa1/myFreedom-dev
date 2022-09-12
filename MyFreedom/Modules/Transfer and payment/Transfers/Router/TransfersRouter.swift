//
//  TransfersRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TransfersRouter {
    
    private weak var view: TransfersViewInput?
    private unowned let commonStore: CommonStore
    
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> TransfersViewInput {
        let viewController = TransfersViewController(style: .grouped)
        let interactor = TransfersInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension TransfersRouter: TransfersRouterInput { }
