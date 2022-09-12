//
//  TPInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TPInteractor {

    private var sections: [TPElement.Section] = []
    private var view: TPViewInput

    init(view: TPViewInput) {
        self.view = view
    }
}

extension TPInteractor: TPInteractorInput {

    func getCountBy(section: Int) -> Int {
        return sections[safe: section]?.elements.count ?? 0
    }

    func getSectiontBy(section: Int) -> TPElement.Section {
        return sections[section]
    }

    func getElementBy(indexPath: IndexPath) -> TPFieldItemElement<TPItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }

    func createElements() {
        sections += [
            .init(id: .favourites, title: "Избранное", elements: [
                    TPFieldItemElement(
                        id: .favourites,
                        title: "",
                        fieldType: .favourites(items: [
                            TPIViewModel(title: "Tele2", icon: BaseImage.tele2operator),
                            TPIViewModel(title: "Onay", icon: BaseImage.onayTransport),
                            TPIViewModel(title: "Tele2", icon: BaseImage.tele2operator),
                            TPIViewModel(title: "Onay", icon: BaseImage.onayTransport),
                            TPIViewModel(title: "Tele2", icon: BaseImage.tele2operator),
                            TPIViewModel(title: "Onay", icon: BaseImage.onayTransport)
                        ])
                    )
                ]
            ),
            .init(id: .transfers, title: "Переводы", elements: [
                TPFieldItemElement(
                    id: .transfers,
                    title: "",
                    fieldType: .transfers(items: [
                        TPIViewModel(title: "Между своими счетами", icon: BaseImage.pdTransfer),
                        TPIViewModel(title: "По номеру телефона", icon: BaseImage.pdTransfer),
                        TPIViewModel(title: "По номеру карты", icon: BaseImage.pdTransfer),
                        TPIViewModel(title: "Конвертация", icon: BaseImage.pdTransfer)
                    ]))
            ]),
            .init(id: .payments, title: "Платежи", elements: [
                TPFieldItemElement(
                    id: .payments,
                    title: "",
                    fieldType: .transfers(items: [
                        TPIViewModel(title: "ЖКХ", icon: BaseImage.pdReferences),
                        TPIViewModel(title: "Здравоохранение", icon: BaseImage.pdReferences),
                        TPIViewModel(title: "Транспорт", icon: BaseImage.pdReferences)
                    ]))
            ]),
            .init(id: .publicServices, title: "Госуслуги", elements: [
                TPFieldItemElement(
                    id: .publicServices,
                    title: "",
                    fieldType: .transfers(items: [
                        TPIViewModel(title: "ЖКХ", icon: BaseImage.pdReferences),
                        TPIViewModel(title: "Здравоохранение", icon: BaseImage.pdReferences),
                        TPIViewModel(title: "Транспорт", icon: BaseImage.pdReferences)
                    ]))
            ]),
            .init(id: .history, title: "История",
                  elements: [
                    TPFieldItemElement(
                        id: .history,
                        image: BaseImage.transactionMagnum.uiImage,
                        title: "Пополнение баланса Onay",
                        subtitle: "45645764574765",
                        amount: Balance(amount: -1100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .history,
                        image: BaseImage.transactionAparking.uiImage,
                        title: "Алексей Н.",
                        subtitle: "+7 (707) 566-65-44",
                        amount: Balance(amount: -1100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .history,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -1000.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .history,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .history,
                        image: BaseImage.pdReplenishment.uiImage,
                        title: "Пополнение депозита",
                        subtitle: "Пополнение",
                        amount: Balance(amount: -1100.56, currency: .KZT),
                        caption: "Freedom Card",
                        showSeparator: false,
                        fieldType: .history
                    )
                  ]
            )
        ]
        view.reload()
    }

    func getSectionsCount() -> Int {
        return sections.count
    }
    
    func didSelectItem(at indexPath: IndexPath) {
//        guard let id = getItemBy(indexPath: indexPath)?.fieldType else { return }
//        switch id {
//        case .card(let type):
//            view.routeToCardDetail(type: type)
//        case .account:
//            view.routeToAccountDetail()
//        case .deposit(let type):
//            view.routeToDepositsDetail(type: type)
//        default: break
//        }
    }

    func didSelectShowAll(at section: Int) {
        guard let item = sections[safe: section]?.id else { return }

        switch item {
        case .transfers:
            view.routeToTransfers()
        case .favourites:
            view.routeToFavorites()
        default:
            break
        }
    }
}
