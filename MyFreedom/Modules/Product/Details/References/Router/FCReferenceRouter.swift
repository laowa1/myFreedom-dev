//
//  FCReferncesRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import Foundation

class FCReferenceRouter {

    private var view: FCReferencesViewInput?
    private unowned let commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> FCReferencesViewInput {
        let viewController = FCReferencesViewController()
        let interactor = FCReferencesInteractor(view: viewController)

        view = viewController
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension FCReferenceRouter: CalendarDelegate {

    func didSelect(fromDate: Date?, toDate: Date?) {
        guard let view = view else { return }
        (view as? FCReferencesViewController)?.interactor?.didSelect(fromDate: fromDate, toDate: toDate)
    }
}

extension FCReferenceRouter: FCReferencesRouterInput {
    
    func popViewContoller() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToCalendarPage(minDate: Date, selectableDaysCount: Int) {
        let contentViewController = CalendarViewController()
        contentViewController.headerTitle = "Выберите период"
        contentViewController.headerRightButtonTitle = "Сбросить"
        contentViewController.minDate = minDate
        contentViewController.canSelectPeriod = true
        contentViewController.delegate = self
        view?.present(contentViewController, animated: true)
    }
}
