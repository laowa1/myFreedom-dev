//
//  HomeInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

protocol HomeInteractorInput: AnyObject {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getSectiontBy(section: Int) -> HomeTable.Section
    func getElementBy(id: IndexPath) -> HomeFieldItemElement
    func createElements()
    func presentOpenCardActions()
    func expand(section: Int)
    func didSelectItem(at indexPath: IndexPath)
}
