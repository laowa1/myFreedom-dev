//
//  IncomeCardRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import Foundation

class IncomeCardRouter {

    private var view:  IncomeCardViewInput?
    private var commonStore: CommonStore

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> IncomeCardViewInput {

        let viewController = IncomeCardViewController()
        let interactor = IncomeCardInteractor(view: viewController)

        viewController.router = self
        viewController.interactor = interactor
        self.view = viewController

        return viewController
    }
}

extension IncomeCardRouter: IncomeCardRouterInput {

    func showPeriodSelection(module: BaseDrawerContentViewControllerProtocol) {
        view?.presentBottomDrawerViewController(with: module)
    }

    func routeToBack() {
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

extension IncomeCardRouter: CalendarDelegate {

    func didSelect(fromDate: Date?, toDate: Date?) {
        guard let view = view else { return }
        (view as? IncomeCardViewController)?.interactor?.didSelect(fromDate: fromDate, toDate: toDate)
    }
}
