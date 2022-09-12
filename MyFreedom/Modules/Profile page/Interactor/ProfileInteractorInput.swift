//
//  ProfileInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import UIKit.UITableViewCell

protocol ProfileInteractorInput {
    func getItemBy(indexPath: IndexPath) -> ProfileFieldItemElement<ProfileItemId>?
    func getItemCountIn(section: Int) -> Int
    func getSectionCount() -> Int
    func getSectiontBy(section: Int) -> ProfileTable.Section
    func createElements()
    func disablePasscodeUsage()
    func didSelectItem(at indexPath: IndexPath)
    func switcher(isOn: Bool, at indexPath: IndexPath)
    func getDigitalDocumentCell(from: [UITableViewCell]) -> UITableViewCell
}
