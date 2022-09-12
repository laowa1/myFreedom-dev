//
//  PDBDepositContainerRouter.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

class PDBDepositContainerRouter {
    
    private var view: PDBDepositContainerViewInput?
    private unowned let commonStore: CommonStore
    private let parentRouter: BaseViewController
    private let type: PDBDepositType
 
    init(type: PDBDepositType, parentRouter: BaseViewController, commonStore: CommonStore) {
        self.type = type
        self.parentRouter = parentRouter
        self.commonStore = commonStore
    }
    
    func build() -> PDBDepositContainerViewInput {
        let viewController = PDBDepositContainerViewController()
        let interactor = PDBDepositContainerInteractor(
            type: type,
            view: viewController,
            logger: commonStore.logger
        )
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension PDBDepositContainerRouter: PDBDepositContainerRouterInput {
    
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

    func routeToDepositReward() {
        let vc = DepositRewardsRouter(commonStore: commonStore).build()
        parentRouter.push(vc)
    }
}
