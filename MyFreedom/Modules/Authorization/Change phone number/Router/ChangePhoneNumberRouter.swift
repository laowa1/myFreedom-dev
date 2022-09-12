//
//  ChangePhoneNumberRouterInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.04.2022.
//

import UIKit

protocol ChangePhoneDelegate: AnyObject {
    func confirm()
}

class ChangePhoneNumberRouter {

    private var view: ChangePhoneNumberViewInput?
    private weak var delegate: ChangePhoneDelegate?
    private unowned let commonStore: CommonStore
    private let isHiddenBack: Bool
    private let phone: String?
    private let isPopToRoot: Bool
    private var idVerificationChangePhone = UUID()

    init(
        delegate: ChangePhoneDelegate? = nil,
        commonStore: CommonStore,
        isHiddenBack: Bool = false,
        phone: String? = nil,
        isPopToRoot: Bool = true
    ) {
        self.delegate = delegate
        self.commonStore = commonStore
        self.isHiddenBack = isHiddenBack
        self.phone = phone
        self.isPopToRoot = isPopToRoot
    }

    func build() -> ChangePhoneNumberViewInput {
        let viewController = ChangePhoneNumberViewContoller()
        view = viewController

        let interactor = ChangePhoneNumberInteractor(
            view: viewController,
            delegate: delegate,
            isHiddenBack: isHiddenBack,
            phone: phone
        )
        viewController.router = self
        viewController.interactor = interactor

        return viewController
    }
}

extension ChangePhoneNumberRouter: ChangePhoneNumberRouterInput {

    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        view?.presentBottomDrawerViewController(with: module)
    }

    func routeToVerification(phone: String, id: UUID) {
        let vc = VerificationRouter(
            phone: phone,
            type: .forgotPassword,
            parentRouter: self,
            commonStore: commonStore,
            resendTime: commonStore.codeConfirmationResendTime,
            id: id
        ).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func routeToRegistration() { }

    func popToRoot() {
        if isPopToRoot {
            view?.navigationController?.popToRootViewController(animated: true)
        } else {
            view?.navigationController?.popViewController(animated: true)
        }
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
    
    func routeToLoader() {
        let vc = VVLRouter(parentRouter: self, commonStore: commonStore).build()
        view?.push(vc)
    }
}

extension ChangePhoneNumberRouter: VerificationParentRouter  {

    func confirm(id: UUID) {
        (view as? ChangePhoneNumberViewContoller)?.interactor?.validate(with: id)
    }

    func fail(id: UUID) {

    }

    func resend(id: UUID) {

    }
}

extension ChangePhoneNumberRouter: ParentRouterInput {
    func pass(_ object: Any) {
        if let str = object as? String, str == "VVL" {
            view?.navigationController?.popToViewController(ofClass: ProfileViewController.self)
            delegate?.confirm()
        }
    }
}
