//
//  CHCPresentationRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//

import Foundation

protocol JCPresentationRouterInput {
    func routeToOpenJuniorCard()
    func routeToBack()
}

class JCPresentationRouter {

    var commonStore: CommonStore
    var view: JCPresentationViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> JCPresentationViewInput {
        let viewController = JCPresentationViewController()
        let interactor = JCPresentationInteractor(view: viewController)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController

        return viewController
    }

}

extension JCPresentationRouter: JCPresentationRouterInput {

    func routeToOpenJuniorCard() {
        let vc = JCOpenRouter(commonStore: commonStore).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func routeToBack() {
        view?.dismiss(animated: true, completion: nil)
    }
}
