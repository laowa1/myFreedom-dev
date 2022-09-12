//
//  DepositAwardsIntreactorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import Foundation

protocol DepositRewardsInteractorInput {
    func createElements()
    func getCountBy(section: Int) -> Int
    func getSectionsCount() -> Int
    func getSectiontBy(section: Int) -> DepositRewardsTable.Section
    func getElementBy(id: IndexPath) -> DepositRewardsFieldElement
    func showPeriodSelolection()
    func didSelect(fromDate: Date?, toDate: Date?)
}
