//
//  JCLBPSRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 06.07.2022.
//

import Foundation

class JCLBPSRouter {
    
    private weak var view: JCLBPSViewInput?
    private var delegate: BlockedPaymentsDelegate
    private unowned var commonStore: CommonStore
    private var selectedPayments: [JCLPayments]
    
    init(commonStore: CommonStore, delegate: BlockedPaymentsDelegate, payments: [JCLPayments]) {
        self.commonStore = commonStore
        self.delegate = delegate
        self.selectedPayments = payments
    }
    
    func build() -> JCLBPSViewInput {
        let viewController = JCLBPSViewController()
        let interactor = JCLBPSInteractor(view: viewController, delegate: delegate, payments: selectedPayments)
        
        viewController.router = self
        viewController.interactor = interactor
        
        view = viewController
        return viewController
    }
}

extension JCLBPSRouter: JCLBPSRouterInput {
    
    func routeToBack(payments: [JCLPayments]) {
        view?.passPayments()
        view?.dismiss(animated: true)
    }
    
    func cancelToBack(payments: [JCLPayments]) {
        view?.dismiss(animated: true)
    }
}
