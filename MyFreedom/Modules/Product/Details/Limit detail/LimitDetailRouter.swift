//
//  LimitDetailRouter.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import Foundation

protocol LimitDetailRouterInput {
    func routeToBack()
}

class LimitDetailRouter {

    private var view: LimitDetailViewInput?
    private unowned let commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> LimitDetailViewInput {
        let viewController = LimitDetailViewContoller()
        viewController.router = self
        view = viewController
        return viewController
    }

}

extension LimitDetailRouter: LimitDetailRouterInput {

    func routeToBack() {
        view?.dismiss(animated: true, completion: { [weak view] in
            // TODO: Not work
            view?.navigationController?.popViewController(animated: true)
        })
    }
}
