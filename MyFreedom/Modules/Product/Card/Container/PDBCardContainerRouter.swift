//
//  PDBCardContainerRouter.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

class PDBCardContainerRouter {
    
    private var view: PDBCardContainerViewInput?
    private unowned let commonStore: CommonStore
    private let parentRouter: BaseViewController
    private let type: PDBCardType
 
    init(type: PDBCardType, parentRouter: BaseViewController, commonStore: CommonStore) {
        self.type = type
        self.parentRouter = parentRouter
        self.commonStore = commonStore
    }
    
    func build() -> PDBCardContainerViewInput {
        let viewController = PDBCardContainerViewController()
        let interactor = PDBCardContainerInteractor(
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

extension PDBCardContainerRouter: PDBCardContainerRouterInput {
    
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

    func routeToLimits() {
        let vc: UIViewController
        switch type {
        case .children:
            vc = JCLRouter(commonStore: commonStore).build()
        default:
            vc = PDLimitsRouter(commonStore: commonStore).build()
        }
        parentRouter.push(vc)
    }

    func routeToOrder(type: OrderPlasticCardType) {
        let vc = OrderPlasticCardRouter(
            commonStore: commonStore,
            orderType: type
        ).build()
        parentRouter.push(vc)
    }

    func routeToIncomeCard() {
        let vc = IncomeCardRouter(commonStore: commonStore).build()
        parentRouter.push(vc)
    }
}
