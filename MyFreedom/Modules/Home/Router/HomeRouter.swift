//
//  HomeRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import UIKit.UINavigationController

class HomeRouter {
    
    private weak var view: HomeViewInput?
    private unowned let commonStore: CommonStore
    
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> HomeViewInput {
        let viewController = HomeViewController()
        let interactor = HomeInteractor(view: viewController)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension HomeRouter: HomeRouterInput {

    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        view?.presentBottomDrawerViewController(with: module)
    }
    
    func routeToProfile(animated: Bool) {
        let vc = ProfileRouter(commonStore: commonStore).build()
        vc.hidesBottomBarWhenPushed = true
        view?.push(vc, animated: animated)
    }
    
    func routeToStories() {
        let vc = StoriesRouter(commonStore: commonStore, delegate: self).build()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = view
        view?.present(vc, animated: true)
    }
    
    func routeToCardDetail(type: PDBCardType) {
        let vc = PDBCardsRouter(type: type, commonStore: commonStore).build()
        vc.hidesBottomBarWhenPushed = true
        view?.push(vc)
    }
    
    func routeToAccountDetail() {
        let vc = PDBAccountsRouter(commonStore: commonStore).build()
        vc.hidesBottomBarWhenPushed = true
        view?.push(vc)
    }
    
    func routeToDepositsDetail(type: PDBDepositType) {
        let vc = PDBDepositsRouter(type: type, commonStore: commonStore).build()
        vc.hidesBottomBarWhenPushed = true
        view?.push(vc)
    }

    func routeToJuniorCardPresentation() {
        let vc = JCPresentationRouter(commonStore: commonStore).build()
        view?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    func routeToOpenInvestCard() {
        let vc = OpenInvestCardRouter(parentRouter: self, commonStore: commonStore).build()
        view?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    func routeToDeposit() {
        let vc = DepositSelectedRouter(commonStore: commonStore).build()
        vc.hidesBottomBarWhenPushed = true
        view?.push(vc)
    }
}

extension HomeRouter: ParentRouterInput {

    func pass(_ object: Any) {
        if let srt = object as? String {
            if srt == "newInvest" {
                routeToCardDetail(type: .invest)
            }
        }
    }
}

extension HomeRouter: StoriesDelegate {
    
    var showCloseButton: Bool { true }
    var showNextButton: Bool { false }
    
    func nextButtonAction() { }
}
