//
//  CreatePasswordRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 31.03.2022.
//

import UIKit

protocol CreatePasswordRouterInput: AnyObject {
    func routeToComeUpCode()
}

class CreatePasswordRouter {

    private weak var view: CreatePasswordViewInput?
    private unowned let commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> CreatePasswordViewInput {
        let viewController = CreatePasswordViewController()
        view = viewController
        
        let interactor = CreatePasswordInteractor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension CreatePasswordRouter: CreatePasswordRouterInput {
    
    func routeToComeUpCode() {
        let vc = CUAccessCodeRouter(commonStore: commonStore, type: .comeUp).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
