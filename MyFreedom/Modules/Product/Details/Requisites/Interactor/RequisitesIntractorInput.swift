//
//  CardRequisitesIntractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import Foundation

protocol RequisitesInteractorInput {

    func getCountBy(section: Int) -> Int
    func getSectionsCount() -> Int
    func getSectiontBy(section: Int) -> RequisitesTable.Section
    func getElementBy(id: IndexPath) -> RequisitesFieldElement
    func getHeaderTitle() -> String?
    func writeItemToClipboard(type: RequisiteClipboardType)
}
