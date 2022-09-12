//
//  PDBAccountContainerRouter.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

class PDBAccountContainerRouter {
    
    private var view: PDBAccountContainerViewInput?
    private unowned let commonStore: CommonStore
    private let parentRouter: BaseViewController
 
    init(parentRouter: BaseViewController, commonStore: CommonStore) {
        self.parentRouter = parentRouter
        self.commonStore = commonStore
    }
    
    func build() -> PDBAccountContainerViewInput {
        let viewController = PDBAccountContainerViewController()
        let interactor = PDBAccountContainerInteractor(
            view: viewController,
            logger: commonStore.logger
        )
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension PDBAccountContainerRouter: PDBAccountContainerRouterInput {
    
    func popViewContoller() {
        parentRouter.navigationController?.popViewController(animated: true)
    }
    
    func routeToRequsites(viewModel: RequisiteViewModel) {
        let vc = RequisitesRouter(commonStore: commonStore, viewModel: viewModel).build()
        parentRouter.present(vc, animated: true)
    }
    
    func routeToReference() {
        let vc = FCReferenceRouter(commonStore: commonStore).build()
        parentRouter.push(vc)
    }

    func routeToConditions() {
        let vc = FCConditionsRouter(commonStore: commonStore).build()
        parentRouter.push(vc)
    }
}
