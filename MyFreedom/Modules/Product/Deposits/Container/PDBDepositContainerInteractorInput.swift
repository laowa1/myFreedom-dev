//
//  PDBDepositContainerInteractorInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit.UITableViewCell

protocol PDBDepositContainerInteractorInput {
    func getItemBy(indexPath: IndexPath) -> PDBDepositContainerFieldElement<PDBDepositContainerItemId>?
    func getItemCountIn(section: Int) -> Int
    func getSectionCount() -> Int
    func getSectiontBy(section: Int) -> PDBDepositContainerTable.Section
    func createElements()
    func didSelectItem(at indexPath: IndexPath)
    func switcher(isOn: Bool, at indexPath: IndexPath)
}
