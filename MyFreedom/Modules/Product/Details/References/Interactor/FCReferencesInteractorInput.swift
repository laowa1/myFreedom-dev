//
//  FCReferncesInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import Foundation

protocol FCReferencesInteractorInput {
    func getItemBy(indexPath: IndexPath) -> FCReferenceFieldItemElement
    func getItemCountIn(section: Int) -> Int
    func getSectionCount() -> Int
    func getSectiontBy(section: Int) -> FCReferenceTable.Section
    func createElements()
    func didSelectItem(at indexPath: IndexPath)
    func didSelect(fromDate: Date?, toDate: Date?)
}
