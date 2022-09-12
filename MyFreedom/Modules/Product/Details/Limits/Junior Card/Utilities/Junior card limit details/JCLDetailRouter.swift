//
//  JCLDetailRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.07.2022.
//

import Foundation

protocol JCLDetailRouterInput {
    func routeToBack()
}

class JCLDetailRouter {

    private var view: JCLDetailViewInput?
    private unowned let commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> JCLDetailViewInput {
        let viewController = JCLDetailViewContoller()
        viewController.router = self
        view = viewController
        return viewController
    }

}

extension JCLDetailRouter: JCLDetailRouterInput {

    func routeToBack() {
        view?.dismiss(animated: true, completion: { [weak view] in
            // TODO: Not work
            view?.navigationController?.popViewController(animated: true)
        })
    }
}
