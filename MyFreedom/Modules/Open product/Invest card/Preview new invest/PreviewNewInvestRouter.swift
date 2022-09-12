//
//  PreviewNewInvestRouter.swift
//  MyFreedom
//
//  Created by m1 on 10.07.2022.
//

import Foundation

protocol PreviewNewInvestRouterInput {
    
    func routeToBack()
    func routeToNext()
}

class PreviewNewInvestRouter {

    var commonStore: CommonStore
    var view: PreviewNewInvestViewInput?
    private let parentRouter: ParentRouterInput

    init(parentRouter: ParentRouterInput, commonStore: CommonStore) {
        self.parentRouter = parentRouter
        self.commonStore = commonStore
    }

    func build() -> PreviewNewInvestViewInput {
        let viewController = PreviewNewInvestViewContoller()

        viewController.router = self
        self.view = viewController

        return viewController
    }
}

extension PreviewNewInvestRouter: PreviewNewInvestRouterInput {

    func routeToBack() {
        view?.dismissDrawer(completion: nil)
    }

    func routeToNext() {
        view?.dismissDrawer(completion: nil)
        parentRouter.pass("OTP")
    }
}
