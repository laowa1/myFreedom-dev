//
//  CHCPresentationRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//

import Foundation

protocol OpenInvestCardRouterInput {
    func routeToPreviewNewInvest()
    func routeToOtp(phone: String)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func popToRootShowInvestCard()
    func routeToLoader()
    func routeToBack()
}

class OpenInvestCardRouter {

    var commonStore: CommonStore
    var view:OpenInvestCardViewInput?
    private let parentRouter: ParentRouterInput

    init(parentRouter: ParentRouterInput, commonStore: CommonStore) {
        self.parentRouter = parentRouter
        self.commonStore = commonStore
    }

    func build() -> OpenInvestCardViewInput {
        let viewController = OpenInvestCardViewController()
        let interactor = OpenInvestCardInteractor(view: viewController)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController

        return viewController
    }
}

extension OpenInvestCardRouter: OpenInvestCardRouterInput {

    func routeToPreviewNewInvest() {
        let vc = PreviewNewInvestRouter(parentRouter: self, commonStore: commonStore).build()
        view?.presentBottomDrawerViewController(with: vc, completion: nil)
    }

    func routeToOtp(phone: String) {
        let vc = VerificationRouter(
            phone: phone,
            type: .withoutChange,
            parentRouter: self,
            commonStore: commonStore,
            resendTime: commonStore.codeConfirmationResendTime,
            popToRoot: true,
            delegate: nil,
            id: UUID()
        ).build()
        view?.push(vc, animated: true)
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        let vc = InformPopUpRouter(delegate: delegate, model: model).build()
        view?.push(vc)
    }

    func routeToLoader() {
        let vc = VVLRouter(parentRouter: self, commonStore: commonStore).build()
        view?.push(vc)
    }

    func popToRootShowInvestCard() {
        view?.dismiss(animated: true, completion: { [weak self] in
            self?.parentRouter.pass("newInvest")
        })
    }

    func routeToBack() {
        view?.dismiss(animated: true, completion: nil)
    }
}

extension OpenInvestCardRouter: VerificationParentRouter {

    func confirm(id: UUID) {
        (view as? OpenInvestCardViewController)?.interactor?.validate(with: id)
    }

    func fail(id: UUID) { }

    func resend(id: UUID) { }
}

extension OpenInvestCardRouter: ParentRouterInput {

    func pass(_ object: Any) {
        if let str = object as? String {
            if str == "VVL" {
                (view as? OpenInvestCardViewController)?.interactor?.checkingInDatabases()
            } else if str == "OTP" {
                (view as? OpenInvestCardViewController)?.interactor?.openOtp()
            }
        }
    }
}
