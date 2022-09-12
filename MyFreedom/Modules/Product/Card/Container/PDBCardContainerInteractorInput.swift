//
//  PDBCardContainerInteractorInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit.UITableViewCell

protocol PDBCardContainerInteractorInput {
    func getItemBy(indexPath: IndexPath) -> PDBCardContainerFieldElement<PDBCardContainerItemId>?
    func getItemCountIn(section: Int) -> Int
    func getSectionCount() -> Int
    func getSectiontBy(section: Int) -> PDBCardContainerTable.Section
    func createElements()
    func didSelectItem(at indexPath: IndexPath)
    func didSelectItemBanner(at indexPath: IndexPath)
    func switcher(isOn: Bool, at indexPath: IndexPath)
}
