//
//  TransfersInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

protocol TransfersInteractorInput: AnyObject {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getSectiontBy(section: Int) -> TPElement.Section
    func getElementBy(indexPath: IndexPath) -> TPFieldItemElement<TPItemId>?
    func createElements()
    func didSelectItem(at indexPath: IndexPath)
}
