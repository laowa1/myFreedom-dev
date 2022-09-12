//
//  LoginRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import UIKit

class LoginRouter {

    private weak var view: LoginViewInput?
    private unowned let commonStore: CommonStore
    private let idVerificationForgot = UUID()
    private let idVerificationChangePhone = UUID()

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> LoginViewInput {
        let viewController = LoginViewController()
        view = viewController
        
        let interactor = LoginInteractor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension LoginRouter: LoginRouterInput {
    
    func routeToComeUpCode() {
        let vc = CUAccessCodeRouter(commonStore: commonStore, type: .comeUp).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToPasswordRecovery(phone: String) {
        let vc = VerificationRouter(
            phone: phone,
            type: .forgotPassword,
            parentRouter: self,
            commonStore: commonStore,
            resendTime: commonStore.codeConfirmationResendTime,
            id: idVerificationForgot
        ).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToChangingPhoneNumber(delegate: SIVConfirmButtonDelegate, id: UUID) {
        let interactor = SIVPhoneInteractor()
        interactor.id = id
        let vc = SIVRouter(interactor: interactor, delegate: delegate).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        let vc = InformPopUpRouter(delegate: delegate, model: model).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToVerification(phone: String) {
        let vc = VerificationRouter(
            phone: phone,
            type: .forgotPassword,
            parentRouter: self,
            commonStore: commonStore,
            resendTime: commonStore.codeConfirmationResendTime,
            id: idVerificationChangePhone
        ).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID) {
        let interactor = SIVIinInteractor()
        interactor.id = id
        let vc = SIVRouter(interactor: interactor, delegate: delegate).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginRouter: VerificationParentRouter {
    
    func confirm(id: UUID) {
        switch id {
        case idVerificationForgot:
            (view as? LoginViewController)?.interactor?.openIdentity()
        case idVerificationChangePhone:
            (view as? LoginViewController)?.interactor?.openEnterIIN()
        default: break
        }
        
    }
    
    func fail(id: UUID) {
        
    }
    
    func resend(id: UUID) {
        
    }
}
