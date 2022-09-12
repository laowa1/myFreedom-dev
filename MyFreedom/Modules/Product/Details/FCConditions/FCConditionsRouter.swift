//
//  FCCondotionsRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

protocol FCConditionsRouterInput {
    func routeToBack()
}

class FCConditionsRouter {

    private var view: FCConditionsViewInput?
    private unowned let commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> FCConditionsViewInput {
        let viewController = FCConditionsViewController()
        let interactor = FCConditionsInteractor(view: viewController)

        view = viewController
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension FCConditionsRouter: FCConditionsRouterInput {
    
    func routeToBack() {
        view?.navigationController?.popViewController(animated: true)
    }
}
