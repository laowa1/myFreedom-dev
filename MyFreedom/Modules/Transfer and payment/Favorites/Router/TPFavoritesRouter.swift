//
//  TPFavoritesRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TPFavoritesRouter {
    
    private weak var view: TPFavoritesViewInput?
    private unowned let commonStore: CommonStore
    
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> TPFavoritesViewInput {
        let viewController = TPFavoritesViewController()
        let interactor = TPFavoritesInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension TPFavoritesRouter: TPFavoritesRouterInput {

}
