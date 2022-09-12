//
//  TPFavoritesInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

protocol TPFavoritesInteractorInput: AnyObject {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getSectiontBy(section: Int) -> TPElement.Section
    func getElementBy(indexPath: IndexPath) -> TPFieldItemElement<TPItemId>?
    func generateInital()
    func didSelectItem(at indexPath: IndexPath)
    func showAlert(indexPath: IndexPath)
    func didSelectSegment(at index: Int)
    func swap(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}
