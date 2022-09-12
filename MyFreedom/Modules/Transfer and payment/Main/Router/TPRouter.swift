//
//  TPRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TPRouter {
    
    private weak var view: TPViewInput?
    private weak var searchView: TPSearchViewInput?
    private unowned let commonStore: CommonStore
    
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> TPViewInput {
        let viewController = TPViewController(style: .grouped)
        let interactor = TPInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        searchView = TPSearchRouter(commonStore: commonStore).build()
        viewController.searchViewContoller = searchView
        
        return viewController
    }
}

extension TPRouter: TPRouterInput {

    func routeToTransfers() {
        let vc = TransfersRouter(commonStore: commonStore).build()
        view?.push(vc)
    }

    func routeToFavorites() {
        let vc = TPFavoritesRouter(commonStore: commonStore).build()
        view?.push(vc)
    }
}
