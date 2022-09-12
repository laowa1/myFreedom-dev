//
//  VVLRouter.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 18.04.2022.
//

import Foundation

protocol VVLRouterInput: AnyObject {
    func nextPage()
}

class VVLRouter {

    private var view: VVLViewInput?
    private unowned let commonStore: CommonStore
    private let parentRouter: ParentRouterInput

    init(parentRouter: ParentRouterInput, commonStore: CommonStore, isHiddenBack: Bool = false, phone: String? = nil) {
        self.commonStore = commonStore
        self.parentRouter = parentRouter
    }

    func build() -> VVLViewInput {
        let viewController = VVLViewController()
        view = viewController

        viewController.router = self

        return viewController
    }
}

extension VVLRouter: VVLRouterInput {
    
    func nextPage() {
        parentRouter.pass("VVL")
    }
}
