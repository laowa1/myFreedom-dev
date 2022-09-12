//
//  SixDigitVerificationRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/13/22.
//

import Foundation

class SixDigitVerificationRouter {

    private weak var view: SixDigitVerificationViewInput?
    private unowned let commonStore: CommonStore
    private unowned let parentRouter: VerificationParentRouter
    private let resendTime: TimeInterval
    private let popToRoot: Bool
    private let id: UUID

    init(
        parentRouter: VerificationParentRouter,
        commonStore: CommonStore,
        resendTime: TimeInterval,
        popToRoot: Bool = true,
        id: UUID
    ) {
        self.parentRouter = parentRouter
        self.commonStore = commonStore
        self.resendTime = resendTime
        self.popToRoot = popToRoot
        self.id = id
    }


    func build() -> SixDigitVerificationViewInput {
        
        let viewController = SixDigitVerificationViewController()
        self.view = viewController

        let interactor = SixDigitVerificationInteractor(view: viewController, resendTime: resendTime, id: id)
        viewController.router = self
        viewController.interactor = interactor

        return viewController
    }
}

extension SixDigitVerificationRouter: SixDigitVerififcationRouterInput {
    func routeToBack() {
        if popToRoot {
            view?.navigationController?.popToRootViewController(animated: true)
        } else {
            view?.navigationController?.popViewController(animated: true)
        }
    }

    func confirm(id: UUID) {
        parentRouter.confirm(id: id)
    }

    func fail(id: UUID) { }

    func resend(id: UUID) { }
}
