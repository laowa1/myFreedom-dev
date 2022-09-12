//
//  JCLBPLRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 08.07.2022.
//

import Foundation

class JCLBPLRouter {
    
    private weak var view: JCLBPLViewInput?
    private unowned var commonStore: CommonStore
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> JCLBPLViewInput {
        let viewController = JCLBPLViewController()
        let interactor = JCLBPLInteractor(view: viewController)
        
        viewController.router = self
        viewController.interactor = interactor
        
        view = viewController
        return viewController
    }
}

extension JCLBPLRouter: JCLBPLRouterInput {
    
    func routeToBlockedPaymentSelection(payments: [JCLPayments]?) {
        let vc = JCLBPSRouter(commonStore: commonStore, delegate: self, payments: payments ?? []).build()
        view?.present(vc, animated: true)
    }
}

extension JCLBPLRouter: BlockedPaymentsDelegate {
    
    func passSelectedPayments(_ payments: [JCLPayments]) {
        view?.passPayments(payments)
    }
}
