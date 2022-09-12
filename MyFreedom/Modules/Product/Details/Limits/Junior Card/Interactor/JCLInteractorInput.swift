//
//  JCLInteractorInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import Foundation

protocol JCLInteractorInput {
    func createElements()
    func getBlockedPaymentsCount() -> Int
    func getSectionCount() -> Int
    func getItemCountIn(section: Int) -> Int
    func getItem(section: Int) -> JCLContainerTable.Section
    func presentLimitInfo()
    func switcher(isOn: Bool, at indexPath: IndexPath)
}
