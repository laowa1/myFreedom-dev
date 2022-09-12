//
//  DigitalDocumantsRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 18.05.2022.
//

import Foundation

class DigitalDocumentsRouter {

    private weak var view: DigitalDocumentsViewInput?
    private unowned let commonStore: CommonStore
    private let title: String?
    private let url: URL

    init(commonStore: CommonStore, title: String?, url: URL) {
        self.commonStore = commonStore
        self.title = title
        self.url = url
    }

    func build() -> DigitalDocumentsViewInput {
        let viewController = DigitalDocumentsViewController()
        let interactor = DigitalDocumentsInteractor(view: viewController,
                                                    title: title,
                                                    url: url)

        view = viewController
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension DigitalDocumentsRouter: DigitalDocumentsRouterInput {
    func routeToBack() {
        view?.navigationController?.popViewController(animated: true)
    }
}
