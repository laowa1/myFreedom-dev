//
//  JCOpenRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import Foundation

protocol JCOpenRouterInput {
    func routeToChooseChild(module: SingleSelectionViewInput)
    func routeToEPContacts(module: EPContactsPickerViewInput)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToBack()
    func routeToOtp(phone: String)
    func popToRoot()
}

class JCOpenRouter {

    var commonStore: CommonStore
    var view: JCOpenViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> JCOpenViewInput {
        let viewController = JCOpenViewController()
        let interactor = JCOpenInteractor(view: viewController, commonStore: commonStore)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController

        return viewController
    }
}

extension JCOpenRouter: JCOpenRouterInput {

    func routeToOtp(phone: String) {
        let vc = VerificationRouter(
            phone: phone,
            type: .forgotPassword,
            parentRouter: self,
            commonStore: commonStore,
            resendTime: commonStore.codeConfirmationResendTime,
            popToRoot: true,
            delegate: nil,
            id: UUID()
        ).build()
        view?.push(vc, animated: true)
    }

    func routeToEPContacts(module: EPContactsPickerViewInput) {
        view?.navigationController?.pushViewController(module, animated: true)
    }

    func routeToBack() {
        view?.dismiss(animated: true, completion: nil)
    }

    func routeToChooseChild(module: SingleSelectionViewInput) {
        self.view?.navigationController?.pushViewController(module, animated: true)
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        let vc = InformPopUpRouter(delegate: delegate, model: model).build()
        view?.push(vc)
    }

    func popToRoot() {
        view?.dismiss(animated: true, completion: nil)
    }
}


extension JCOpenRouter: VerificationParentRouter {

    func confirm(id: UUID) {
        (view as? JCOpenViewController)?.interactor?.openSuccessPage()
    }

    func fail(id: UUID) { }

    func resend(id: UUID) { }
}
