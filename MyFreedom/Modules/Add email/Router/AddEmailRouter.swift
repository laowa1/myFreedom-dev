//
//  EmailChangeRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/12/22.
//

import Foundation

protocol AddEmailDelegate: AnyObject {
    
    func confirmAddEmail()
}

class AddEmailRouter {

    private var view: AddEmailViewInput?
    private weak var delegate: AddEmailDelegate?
    private unowned let commonStore: CommonStore
    private let emailVerifyId = UUID()

    init(delegate: AddEmailDelegate, commonStore: CommonStore) {
        self.delegate = delegate
        self.commonStore = commonStore
    }

    func build() -> AddEmailViewInput {
        let viewController = AddEmailViewController()
        view = viewController

        let interactor = AddEmailInteractor(view: viewController)
        viewController.router = self
        viewController.interactor = interactor

        return viewController
    }

}

extension AddEmailRouter: AddEmailRouterInput {

    func routeToBack() {
        view?.navigationController?.popToRootViewController(animated: true)
    }

    func routeToEmailVerification() {
        let vc = SixDigitVerificationRouter(parentRouter: self,
                                         commonStore: commonStore,
                                         resendTime: commonStore.codeConfirmationResendTime,
                                         id: emailVerifyId).build()
        view?.push(vc)
    }
}

extension AddEmailRouter: VerificationParentRouter {
    
    func confirm(id: UUID) {
        view?.navigationController?.popToViewController(ofClass: ProfileViewController.self)
        delegate?.confirmAddEmail()
    }

    func fail(id: UUID) { }

    func resend(id: UUID) { }
}
