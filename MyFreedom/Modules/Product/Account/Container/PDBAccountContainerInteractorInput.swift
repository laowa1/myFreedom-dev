//
//  PDBAccountContainerInteractorInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit.UITableViewCell

protocol PDBAccountContainerInteractorInput {
    func getItemBy(indexPath: IndexPath) -> PDBAccountContainerFieldElement<PDBAccountContainerItemId>?
    func getItemCountIn(section: Int) -> Int
    func getSectionCount() -> Int
    func getSectiontBy(section: Int) -> PDBAccountContainerTable.Section
    func createElements()
    func didSelectItem(at indexPath: IndexPath)
}
