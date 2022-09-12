//
//  FCConditionsInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

protocol FCConditionsInteractorInput {
    func createElements()
    func getItemBy(indexPath: IndexPath) -> FCConditionsFieldItemElement
    func getItemCountIn(section: Int) -> Int
}

class FCConditionsInteractor {

    private unowned var view: FCConditionsViewInput
    private var elements = [FCConditionsFieldItemElement]()

    init(view: FCConditionsViewInput) {
        self.view = view
    }
}

extension FCConditionsInteractor: FCConditionsInteractorInput {

    func createElements() {
        elements += [
            .init(title: "0 ₸", fieldType: .condition, subtitle: "Выпуск и перевыпуск карты"),
            .init(title: "0 ₸", fieldType: .condition, subtitle: "Доставка карты"),
            .init(title: "0 ₸", fieldType: .condition, subtitle: "Пополнение со счетов и карт Freedom Finance Bank"),
            .init(title: "0 ₸", fieldType: .condition, subtitle: "Пополнение со счетов и карт других банков РК*"),
            .init(title: "0 ₸", fieldType: .condition, subtitle: "Переводы на карты Freedom Finance Bank"),
            .init(title: "0 ₸", fieldType: .condition, subtitle: "Комиссия на снятие в банкоматах, до 1200 USD в месяц"),
            .init(title: "", fieldType: .terms, subtitle: "*Согласно тарифам сторонних банков за P2P, Swift и иные переводы")
        ]

        view.reloadData()
    }

    func getItemBy(indexPath: IndexPath) -> FCConditionsFieldItemElement {
        elements[indexPath.row]
    }

    func getItemCountIn(section: Int) -> Int {
        elements.count
    }
}
