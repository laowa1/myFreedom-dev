//
//  EPContactsPickerRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 07.07.2022.
//


import Foundation

protocol EPContactsPickerRouterInput {
    func routeToBack()
    func routeToPervious()
    func routeToNext()
}

class EPContactsPickerRouter {

    private var commonStore: CommonStore
    private var view: EPContactsPickerViewInput?
    var viewModel: EPContactsPickerViewModel

    init(commonStore: CommonStore, viewModel: EPContactsPickerViewModel) {
        self.commonStore = commonStore
        self.viewModel = viewModel
    }

    func build() -> EPContactsPickerViewInput {
        let viewController = EPContactsPicker()
        let interactor = EPContactsPickerInteractor(view: viewController, viewModel: viewModel)

        viewController.router = self
        viewController.interactor = interactor
        viewController.contactDelegate = viewModel.delegate
        self.view = viewController

        return viewController
    }
}

extension EPContactsPickerRouter: EPContactsPickerRouterInput {

    func routeToBack() {
        view?.navigationController?.popToRootViewController(animated: true)
    }

    func routeToNext() {
        guard let nextModule = viewModel.nextModule else { return }

        if let vc = view?.navigationController?.viewControllers.first(where: { $0 == nextModule }) {
            view?.navigationController?.popToViewController(vc, animated: true)
            return
        }

        view?.navigationController?.pushViewController(nextModule, animated: true)
    }

    func routeToPervious() {
        view?.navigationController?.popViewController(animated: true)
    }
}
