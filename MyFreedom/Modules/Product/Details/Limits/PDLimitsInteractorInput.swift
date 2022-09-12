//
//  PDLimitsInteractorInput.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import Foundation

protocol PDLimitsInteractorInput {
    func createElements()
    func getItemsCount() -> Int
    func getItemsElementBy(id: IndexPath) -> PDLimitsElement
    func showAlert(index: IndexPath)
    func expand(section: Int)
    func presentInfoBS()
}
