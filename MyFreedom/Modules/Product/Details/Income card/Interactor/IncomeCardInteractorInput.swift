//
//  IncomeCardInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import Foundation

protocol IncomeCardInteractorInput {
    func createElements()
    func getCountBy(section: Int) -> Int
    func getSectionsCount() -> Int
    func getSectiontBy(section: Int) -> IncomeCardTable.Section
    func getElementBy(id: IndexPath) -> IncomeCardFieldElement
    func showPeriodSelolection()
    func didSelect(fromDate: Date?, toDate: Date?)
}
