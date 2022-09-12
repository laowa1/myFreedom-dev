//
//  CardRequisitesInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import Foundation

class RequisitesInteractor {
    
    private var view: RequisitesViewInput?
    private var viewModel: RequisiteViewModel
    
    init(view: RequisitesViewInput, viewModel: RequisiteViewModel) {
        self.view = view
        self.viewModel = viewModel
        self.view?.reload()
    }
}

extension RequisitesInteractor: RequisitesInteractorInput {

    func getCountBy(section: Int) -> Int {
        return viewModel.sections[section].elements.count
    }
    
    func getSectionsCount() -> Int {
        return viewModel.sections.count
    }
    
    func getSectiontBy(section: Int) -> RequisitesTable.Section {
        return viewModel.sections[section]
    }
    
    func getElementBy(id: IndexPath) -> RequisitesFieldElement {
        return viewModel.sections[id.section].elements[id.row]
    }

    func getItemCountIn(section: Int) -> Int {
        return viewModel.sections[section].elements.count
    }

    func writeItemToClipboard(type: RequisiteClipboardType) {
        var message = ""
        switch type {
        case .cardNumber:
            message = "Номер карты cкопировано"
        case .cvv:
            message =  "CVV cкопировано"
        case .requisite:
            message = "Скопировано"
        }

        view?.showAlertOnTop(withMessage: message, lottie: .copied)
    }

    func getHeaderTitle() -> String? {
        switch viewModel.type {
        case .card:
            return "Реквезиты карты"
        case .account:
            return "Реквезиты счета"
        }
    }
}
