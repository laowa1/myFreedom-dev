//
//  DepositAwardsViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import Foundation

protocol DepositRewardsViewInput: BaseViewControllerProtocol {
    func reload()
    func showPeriodSelection(module: BaseDrawerContentViewControllerProtocol)
    func routeToCalendarPage(minDate: Date, selectableDaysCount: Int)
}
