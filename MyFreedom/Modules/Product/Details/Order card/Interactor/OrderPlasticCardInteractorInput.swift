//
//  OrderCardInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

protocol OrderPlasticCardInteractorInput {
    func createElements()
    func getItemBy(indexPath: IndexPath) -> OrderPalsticCardElement
    func getItemCountIn(section: Int) -> Int
    func getSectionCount() -> Int
    func getSectiontBy(section: Int) -> OrderPalsticCardTable.Section
    func didSelectItem(at indexPath: IndexPath)
    func getModel(currentLevelIndex: Int) -> InputLevelModel
    func updateValues()
}
