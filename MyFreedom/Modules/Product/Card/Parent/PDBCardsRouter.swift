//
//  PDBCardsRouter.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import Foundation

protocol PDBCardsRouterInput: AnyObject {
    
    func routeToRenameCard(name: String)
}

class PDBCardsRouter {
    
    private var view: PDBCardsViewInput?
    private var containerView: PDBCardContainerViewInput?
    private unowned let commonStore: CommonStore
    private let type: PDBCardType
    
    init(type: PDBCardType, commonStore: CommonStore) {
        self.type = type
        self.commonStore = commonStore
    }
    
    func build() -> PDBCardsViewInput {
       
        let viewController = PDBCardsViewContoller()
        let interactor = PDBCardsInteractor(type: type, view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        containerView = PDBCardContainerRouter(type: type, parentRouter: viewController, commonStore: commonStore).build()
        viewController.containerController = containerView
        
        return viewController
    }
}

extension PDBCardsRouter: PDBCardsRouterInput {
    
    func routeToRenameCard(name: String) {
        let viewController = DepositRenameRouter(commonStore: commonStore, name: name).build()
        view?.present(viewController, animated: true)
    }
}
