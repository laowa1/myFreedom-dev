//
//  CUAccessCodeRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 31.03.2022.
//

import Foundation
import UIKit

class CUAccessCodeRouter {

    private weak var view: CUAccessCodeViewInput?
    private weak var delegate: AccessCodeDelegate?
    private unowned let commonStore: CommonStore
    private let popToRoot: Bool
    private var code: String
    private let type: CUAccessCodeType

    init(
        delegate: AccessCodeDelegate? = nil,
        commonStore: CommonStore,
        popToRoot: Bool = true,
        code: String = "",
        type: CUAccessCodeType
    ) {
        self.delegate = delegate
        self.popToRoot = popToRoot
        self.code = code
        self.type = type
        self.commonStore = commonStore
    }

    func build() -> CUAccessCodeViewInput {
        let viewController = CUAccessCodeViewContoller()
        view = viewController
        
        let interactor = CUAccessCodeInteractor(
            delegate: delegate,
            confirmationCode: code,
            type: type,
            view: viewController
        )
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension CUAccessCodeRouter: CUAccessCodeRouterInput {
    
    func routeToBack() {
        if popToRoot {
            view?.navigationController?.popToRootViewController(animated: true)
        } else {
            view?.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToRepeat(code: String, popToRoot: Bool, type: CUAccessCodeType) {
        let vc = CUAccessCodeRouter(delegate: delegate, commonStore: commonStore, popToRoot: popToRoot, code: code, type: type).build()
        view?.push(vc)
    }
    
    func routeToInform(deledate: InformPUButtonDelegate, model: InformPUViewModel) {
        let vc = InformPopUpRouter(delegate: deledate, model: model, popToRoot: false).build()
        view?.push(vc)
    }

    func login() {
        let vc = MainTabBarRouter(commonStore: commonStore).build()
        view?.present(NavigationController(rootViewController: vc), animated: true, completion: { [weak self] in
            self?.view?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func closeSession() {
        view?.navigationController?.popToRootViewController(animated: false)
        view?.push(AuthorizationRouter(commonStore: commonStore, isHiddenBack: true).build(), removeCurrent: true, animated: true)
    }
}
