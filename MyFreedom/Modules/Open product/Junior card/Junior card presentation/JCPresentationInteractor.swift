//
//  CHCPresentationInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//

import Foundation

protocol JCPresentationInteractorInput {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getElementBy(id: IndexPath) -> JCPersentationFieldItemElement
    func getSectiontBy(section: Int) -> JCPersentationTable.Section
    func getTermsString() -> NSAttributedString
    func createElements()
}

class JCPresentationInteractor {

    private var view: JCPresentationViewInput?
    private var sections = [JCPersentationTable.Section]()

    init(view: JCPresentationViewInput) {
        self.view = view
    }
}

extension JCPresentationInteractor: JCPresentationInteractorInput {

    func getSectionsCount() -> Int {
        sections.count
    }

    func getCountBy(section: Int) -> Int {
        sections[section].elements.count
    }

    func getElementBy(id: IndexPath) -> JCPersentationFieldItemElement {
        sections[id.section].elements[id.row]
    }

    func getSectiontBy(section: Int) -> JCPersentationTable.Section {
        sections[section]
    }

    func getTermsString() -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "Продолжая, вы принимаете")
        attrString.append(NSAttributedString(string: " условия банка", attributes: [.foregroundColor: BaseColor.green500]))

        return attrString
    }

    func createElements() {
        sections += [
            .init(id: .card, elements: [
                .init(image: BaseImage.JC.uiImage, fieldType: .card)
            ]),

            .init(id: .features, elements: [
                .init(image: BaseImage.JCFeature.uiImage, title: "3% годовых — ежедневное начисление дохода в USD", fieldType: .features, description: "На остаток D-счёта от Freedom Finance Global PLC.")
            ]),

            .init(id: .features, elements: [
                .init(image: BaseImage.JCFeature.uiImage, title: "3% годовых — ежедневное начисление дохода в USD", fieldType: .features, description: "На остаток D-счёта от Freedom Finance Global PLC.")
            ]),

            .init(id: .rates, title: "Тарифы карты", elements: [
                .init(title: "0 ₸", fieldType: .rate, description: "Выпуск и доставка"),
                .init(title: "0 ₸", fieldType: .rate, description: "Годовое обслуживание"),
                .init(title: "0 ₸", fieldType: .rate, description: "Пополнение со счетов и карт Freedom Finance Bank и карт других банков РК*"),
                .init(title: "0 ₸", fieldType: .rate, description: "Обналичивание в банкоматах и POS-терминалах любых банков в пределах РК до 500 000 ₸"),
                .init(fieldType: .rateInfo, description: "* У других банков может быть своя комиссия за переводы. Смотрите тарифы на их сайтах")
            ]),

            .init(id: .button, elements: [
                .init(title: "Открыть Детскую карту", fieldType: .button)
            ])
        ]

        view?.reload()
    }
}
