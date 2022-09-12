//
//  DepositRenameRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 27.06.2022.
//

import UIKit

protocol DepositRenameRouterInput {
    func routeToBack()
}

class DepositRenameRouter: DepositRenameRouterInput {

    private var view: DepositRenameViewInput?
    private var commonStore: CommonStore
    private var name: String?

    init(commonStore: CommonStore, name: String) {
        self.commonStore = commonStore
        self.name = name
    }

    func build()-> DepositRenameViewInput {

        let viewController = DepositRenameViewController()
        let interactor = DepositRenameInteractor(view: viewController, name: name ?? "")

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController


        return viewController
    }

    func routeToBack() {
        view?.dismiss(animated: true, completion: nil)
    }
}
