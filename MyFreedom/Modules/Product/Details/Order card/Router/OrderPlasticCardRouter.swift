//
//  OrderCardRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

class OrderPlasticCardRouter {

    private var view: OrderPlasticCardViewInput?
    private var commonStore: CommonStore
    private var orderType: OrderPlasticCardType
    
    init(commonStore: CommonStore, orderType: OrderPlasticCardType) {
        self.commonStore = commonStore
        self.orderType = orderType
    }

    func build()-> OrderPlasticCardViewInput {

        let viewController = OrderPlasticCardViewController()
        let interactor = OrderPlasticCardInteractor(view: viewController, orderType: orderType)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController


        return viewController
    }
    
}

extension OrderPlasticCardRouter: OrderPlasticCardRouterInput {

    func routeToBack() {
        self.view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToInput(model: InputLevelModel) {
        let vc = CDIRouter(commonStore: commonStore, model: model, delegate: self).build()
        view?.present(NavigationController(rootViewController: vc), animated: true)
    }
}

extension OrderPlasticCardRouter: CDIUpdaterDelegate {
    func update() {
        (view as? OrderPlasticCardViewController)?.interactor?.updateValues()
    }
}
