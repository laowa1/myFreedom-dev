//
//  TPSearchInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class TPSearchInteractor {

    private var sections: [TPElement.Section] = []
    private var view: TPSearchViewInput

    init(view: TPSearchViewInput) {
        self.view = view
    }
}

extension TPSearchInteractor: TPSearchInteractorInput {

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
        sections = [
            .init(id: .recentRequests,
                  title: "Последние запросы",
                  buttonTitle: "Очистить",
                  elements: [
                    TPFieldItemElement(
                        id: .recentRequests,
                        image: BaseImage.tpRecentRequests.uiImage,
                        title: "Aparking",
                        fieldType: .recentRequests
                    ),
                    TPFieldItemElement(
                        id: .recentRequests,
                        image: BaseImage.tpRecentRequests.uiImage,
                        title: "Пополнить баланс",
                        fieldType: .recentRequests
                    ),
                    TPFieldItemElement(
                        id: .recentRequests,
                        image: BaseImage.tpRecentRequests.uiImage,
                        title: "Теле2",
                        fieldType: .recentRequests
                    ),
                    TPFieldItemElement(
                        id: .recentRequests,
                        image: BaseImage.tpRecentRequests.uiImage,
                        title: "Жахангер краш",
                        showSeparator: false,
                        fieldType: .recentRequests
                    )
                  ]
            ),
            .init(id: .publicServices,
                  title: "Популярные запросы",
                  buttonTitle: "",
                  elements: [
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.transactionMagnum.uiImage,
                        title: "Пополнение баланса Onay",
                        subtitle: "45645764574765",
                        amount: Balance(amount: 1100.56, currency: .KZT),
                        caption: "Freedom Card",
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.transactionAparking.uiImage,
                        title: "Пополнение баланса",
                        subtitle: "Транспорт",
                        amount: Balance(amount: 1100.56, currency: .KZT),
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
                    )
                  ]
            )
        ]
        view.reload()
    }

    func emptySections() {
        sections = [
            .init(id: .searchEmpty,
                  elements: [
                    TPFieldItemElement(
                        id: .searchEmpty,
                        image: BaseImage.tpRecentRequests.uiImage,
                        title: "К сожелению, мы ничего не нашли по вашему запросу",
                        subtitle: "Попробуйте изменить поисковый запрос и проверить, нет ли опечаток",
                        fieldType: .searchEmpty
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

    func searchTextDidChange(text: String) {
        text.count > 2 ? emptySections() : createElements()
    }
}
