//
//  AuthorizationRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.04.2022.
//

import UIKit

class AuthorizationRouter {

    private var view: AuthorizationViewInput?
    private unowned let commonStore: CommonStore
    private let isHiddenBack: Bool
    private let phone: String?
    private let idVerificationForgot = UUID()

    init(commonStore: CommonStore, isHiddenBack: Bool = false, phone: String? = nil) {
        self.commonStore = commonStore
        self.isHiddenBack = isHiddenBack
        self.phone = phone
    }

    func build() -> AuthorizationViewInput {
        let viewController = AuthorizationViewController()
        view = viewController

        let interactor = AuthorizationInteractor(view: viewController, logger: commonStore.logger, isHiddenBack: isHiddenBack, phone: phone)
        viewController.router = self
        viewController.interactor = interactor

        return viewController
    }
}

extension AuthorizationRouter: AuthorizationRouterInput {
    
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        view?.presentBottomDrawerViewController(with: module)
    }

    func routeToVerification(phone: String, id: UUID) {
        let isAuth = self.phone == nil
        let vc = VerificationRouter(
            phone: phone,
            type: .forgotPassword,
            parentRouter: self,
            commonStore: commonStore,
            resendTime: commonStore.codeConfirmationResendTime,
            popToRoot: true,
            delegate: isAuth ? nil : self,
            id: id
        ).build()
        view?.push(vc, animated: isAuth)
    }

    func routeToRegistration() { }

    func popToRoot() {
        UIView.animate(withDuration: 0.1,
                       animations: { self.view?.view.alpha = 0.3 },
                       completion: { _ in self.view?.dismiss(animated: true) })
    }

    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID) {
        let interactor = SIVIinInteractor()
        interactor.id = id
        let vc = SIVRouter(interactor: interactor, delegate: delegate).build()
        view?.push(vc)
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        let vc = InformPopUpRouter(delegate: delegate, model: model).build()
        view?.push(vc)
    }

    func routeToComeUpCode() {
        let vc = CUAccessCodeRouter(commonStore: commonStore, type: .comeUp).build()
        view?.push(vc)
    }
    
    func routeToWebview(title: String, url: URL) {
        let webView = WebViewController()
        webView.set(title: title, url: url)

        view?.dismiss(animated: true) { [weak self] in
            self?.view?.present(webView, animated: true)
        }
    }
    
    func routeToLoader() {
        let vc = VVLRouter(parentRouter: self, commonStore: commonStore).build()
        view?.push(vc)
    }
}

extension AuthorizationRouter: VerificationParentRouter {

    func confirm(id: UUID) {
        (view as? AuthorizationViewController)?.interactor?.validate(with: id)
    }

    func fail(id: UUID) {

    }

    func resend(id: UUID) {

    }
}

extension AuthorizationRouter: ChangeNumberDelegate {
    func routeChangeNumber() {
        let vc = ChangePhoneNumberRouter(commonStore: commonStore).build()
        view?.push(vc, removeCurrent: true, animated: true)
    }
}

extension AuthorizationRouter: ParentRouterInput {
    func pass(_ object: Any) {
        if let str = object as? String, str == "VVL" {
            routeToComeUpCode()
        }
    }
}
