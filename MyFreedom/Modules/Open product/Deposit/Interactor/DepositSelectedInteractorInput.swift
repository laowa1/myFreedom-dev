//
//  DepositSelectedInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

protocol DepositSelectedInteractorInput: AnyObject {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getSectiontBy(section: Int) -> OPElement.Section
    func getElementBy(indexPath: IndexPath) -> OPFieldItemElement<OPItemId>?
    func generateInital()
    func didSelectItem(at indexPath: IndexPath)
    func didSelectSegment(at index: Int)
}
