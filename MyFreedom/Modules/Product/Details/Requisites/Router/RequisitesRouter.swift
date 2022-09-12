//
//  CardRequisitesRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import UIKit.UIActivityViewController

class RequisitesRouter {

    private var view: RequisitesViewInput?
    private unowned let commonStore: CommonStore
    private var viewModel: RequisiteViewModel

    init(commonStore: CommonStore, viewModel: RequisiteViewModel) {
        self.commonStore = commonStore
        self.viewModel = viewModel
    }
    
    func build()-> RequisitesViewInput {

        let viewController = RequisitesViewController()
        let interactor = RequisitesInteractor(view: viewController, viewModel: viewModel)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController

        return viewController
    }
    
}

extension RequisitesRouter: RequisitesRouterInput {
    
    func routeShare(text: String) {
        let activityVc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        view?.present(activityVc, animated: true, completion: nil)
    }
}
