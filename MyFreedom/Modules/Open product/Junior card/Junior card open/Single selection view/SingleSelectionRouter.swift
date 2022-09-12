//
//  SingleSelectionRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 08.07.2022.
//

import Foundation

protocol SingleSelectionRouterInput {
    func routeToBack()
    func routeToPervious()
    func routeToNext()
}

class SingleSelectionRouter<ID: Equatable> {

    private var commonStore: CommonStore
    private var view: SingleSelectionViewInput?
    var viewModel: SingleSelectionViewModel

    init(commonStore: CommonStore, viewModel: SingleSelectionViewModel) {
        self.commonStore = commonStore
        self.viewModel = viewModel
    }

    func build() -> SingleSelectionViewInput {
        let viewController = SingleSelectionViewController<ID>()
        let interactor = SingleSelectionInteractor(view: viewController, viewModel: viewModel)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController

        return viewController
    }
}

extension SingleSelectionRouter: SingleSelectionRouterInput {

    func routeToPervious() {
        view?.navigationController?.popViewController(animated: true)
    }
    

    func routeToBack() {
        view?.navigationController?.popToRootViewController(animated: true)
    }

    func routeToNext() {
        guard let nextModule = viewModel.nextModule else { return }
        view?.navigationController?.pushViewController(nextModule, animated: true)
    }
}
