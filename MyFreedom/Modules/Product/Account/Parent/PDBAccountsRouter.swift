//
//  PDBAccountsRouter.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import Foundation

protocol PDBAccountsRouterInput: AnyObject { }

class PDBAccountsRouter {
    
    private var view: PDBAccountsViewInput?
    private var containerView: PDBAccountContainerViewInput?
    private unowned let commonStore: CommonStore
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> PDBAccountsViewInput {
       
        let viewController = PDBAccountsViewContoller()
        let interactor = PDBAccountsInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        containerView = PDBAccountContainerRouter(parentRouter: viewController, commonStore: commonStore).build()
        viewController.containerController = containerView
        
        return viewController
    }
}

extension PDBAccountsRouter: PDBAccountsRouterInput { }
