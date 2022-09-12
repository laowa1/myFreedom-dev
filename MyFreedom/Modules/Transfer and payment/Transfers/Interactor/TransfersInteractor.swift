//
//  TransfersInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TransfersInteractor {

    private var sections: [TPElement.Section] = []
    private var view: TransfersViewInput

    init(view: TransfersViewInput) {
        self.view = view
    }
}

extension TransfersInteractor: TransfersInteractorInput {

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
            .init(id: .transfers, elements: [
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdTransfer.uiImage,
                    title: "Между своими счетами",
                    subtitle: "Между счетами, картами, депозитами",
                    fieldType: .accessory
                ),
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdTransfer.uiImage,
                    title: "По номеру телефона",
                    subtitle: "Клиентам Freedom Bank, ForteBank, БЦК и тд.",
                    fieldType: .accessory
                ),
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdTransfer.uiImage,
                    title: "С карты на карту",
                    subtitle: "На карту любого банка РК",
                    fieldType: .accessory
                ),
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdTransfer.uiImage,
                    title: "На брокерский счёт",
                    subtitle: "Пополнение брокерского счета",
                    fieldType: .accessory
                ),
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdTransfer.uiImage,
                    title: "Перевод по реквизитам",
                    subtitle: "Между банками РК",
                    fieldType: .accessory
                ),
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdTransfer.uiImage,
                    title: "SWIFT-перевод",
                    subtitle: "Международные переводы",
                    fieldType: .accessory
                ),
                TPFieldItemElement(
                    id: .transfers,
                    image: BaseImage.pdInternetPayments.uiImage,
                    title: "Конвертация валют",
                    showSeparator: false,
                    fieldType: .accessory
                )
            ]),
            .init(id: .history,
                  title: "История",
                  buttonTitle: "Показать все",
                  elements: [
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Жахангер",
                        subtitle: "+7 (707) 566-65-44",
                        amount: Balance(amount: -100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -1000.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdReplenishment.uiImage,
                        title: "Пополнение депозита",
                        subtitle: "Пополнение",
                        amount: Balance(amount: 1100.56, currency: .KZT),
                        caption: "Freedom Card",
                        showSeparator: false,
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdReplenishment.uiImage,
                        title: "Пополнение депозита",
                        subtitle: "Пополнение",
                        amount: Balance(amount: 1100.56, currency: .KZT),
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
}
