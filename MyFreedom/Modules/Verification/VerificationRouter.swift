//
//  VerificationRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import UIKit

protocol ChangeNumberDelegate: AnyObject {
    func routeChangeNumber()
}

class VerificationRouter {

    private weak var view: VerificationViewInput?
    private unowned let commonStore: CommonStore
    private unowned let parentRouter: VerificationParentRouter
    private let phone: String
    private let type: VerificationType
    private let resendTime: TimeInterval
    private let popToRoot: Bool
    private weak var delegate: ChangeNumberDelegate?
    private let id: UUID

    init(
        phone: String,
        type: VerificationType,
        parentRouter: VerificationParentRouter,
        commonStore: CommonStore,
        resendTime: TimeInterval,
        popToRoot: Bool = true,
        delegate: ChangeNumberDelegate? = nil,
        id: UUID
    ) {
        self.phone = phone
        self.type = type
        self.parentRouter = parentRouter
        self.commonStore = commonStore
        self.resendTime = resendTime
        self.popToRoot = popToRoot
        self.delegate = delegate
        self.id = id
    }

    func build() -> VerificationViewInput {
        let viewController = VerificationViewController()
        view = viewController
        
        let interactor = VerificationInteractor(view: viewController, phone: phone, type: type, resendTime: resendTime, id: id)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension VerificationRouter: VerificationRouterInput {
    
    func confirm(id: UUID) {
        parentRouter.confirm(id: id)
    }
    
    func fail(id: UUID) {
        parentRouter.fail(id: id)
    }
    
    func resend(id: UUID) {
        parentRouter.resend(id: id)
    }
    
    func routeToBack() {
        if popToRoot {
            view?.navigationController?.popToRootViewController(animated: true)
        } else {
            view?.navigationController?.popViewController(animated: true)
        }
    }

    func routeToChangeNumber() {
        guard let delegate = delegate else { return routeToBack() }
        delegate.routeChangeNumber()
    }
}
