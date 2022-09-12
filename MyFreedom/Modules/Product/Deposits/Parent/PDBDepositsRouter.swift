//
//  PDBDepositsRouter.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import Foundation

protocol PDBDepositsRouterInput: AnyObject {
    func routeToRename(name: String)
}

class PDBDepositsRouter {
    
    private var view: PDBDepositsViewInput?
    private var containerView: PDBDepositContainerViewInput?
    private unowned let commonStore: CommonStore
    private let type: PDBDepositType
    
    init(type: PDBDepositType, commonStore: CommonStore) {
        self.type = type
        self.commonStore = commonStore
    }
    
    func build() -> PDBDepositsViewInput {
       
        let viewController = PDBDepositsViewContoller()
        let interactor = PDBDepositsInteractor(type: type, view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        containerView = PDBDepositContainerRouter(type: type, parentRouter: viewController, commonStore: commonStore).build()
        viewController.containerController = containerView
        
        return viewController
    }
}

extension PDBDepositsRouter: PDBDepositsRouterInput {

    func routeToRename(name: String) {
        let viewController = DepositRenameRouter(commonStore: commonStore, name: name).build()
        view?.present(viewController, animated: true)
    }
}
