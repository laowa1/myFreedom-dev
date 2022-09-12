//
//  TPFavoritesInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

enum TPFavoritesType: CaseIterable {
    case transfer, payment

    var title: String {
        switch self {
        case .transfer: return "Переводы"
        case .payment: return "Платежи"
        }
    }
}

class TPFavoritesInteractor {

    private class var types: [TPFavoritesType] { TPFavoritesType.allCases }
    private var sections: [TPElement.Section] = []
    private var view: TPFavoritesViewInput
    private var selectedSegmentIndex = 0

    init(view: TPFavoritesViewInput) {
        self.view = view
    }
}

extension TPFavoritesInteractor: TPFavoritesInteractorInput {

    func getCountBy(section: Int) -> Int {
        return sections[safe: section]?.elements.count ?? 0
    }

    func getSectiontBy(section: Int) -> TPElement.Section {
        return sections[section]
    }

    func getElementBy(indexPath: IndexPath) -> TPFieldItemElement<TPItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }

    func generateInital() {
        view.pass(segmentTitles: Self.types.map { $0.title })
        createTranferElements()
    }

    func createTranferElements() {
        sections = [
            .init(id: .favourites,
                  elements: [
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        accessory: BaseImage.dots.uiImage,
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        accessory: BaseImage.dots.uiImage,
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.pdReplenishment.uiImage,
                        title: "Пополнение депозита",
                        subtitle: "Пополнение",
                        showSeparator: false,
                        accessory: BaseImage.dots.uiImage,
                        fieldType: .history
                    )
                  ]
            )
        ]
        view.reload()
    }

    func createPaymentsElements() {
        sections = [
            .init(id: .favourites,
                  elements: [
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.transactionMagnum.uiImage,
                        title: "Пополнение баланса Onay",
                        subtitle: "45645764574765",
                        accessory: BaseImage.dots.uiImage,
                        fieldType: .history
                    ),
                    TPFieldItemElement(
                        id: .publicServices,
                        image: BaseImage.transactionAparking.uiImage,
                        title: "Пополнение баланса",
                        subtitle: "Транспорт",
                        accessory: BaseImage.dots.uiImage,
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
                        id: .favoritesEmpty,
                        image: BaseImage.favoritesEmpty.uiImage,
                        title: selectedSegmentIndex == 0 ? "У вас пока нет избранных переводов" : "У вас пока нет избранных платежей",
                        fieldType: .favoritesEmpty
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

    func showAlert(indexPath: IndexPath) {
        guard let title = sections[safe: indexPath.section]?.elements[safe: indexPath.row]?.title else { return }
        view.showAlert(
            title: title,
            message: nil,
            style: .actionSheet,
            actions: [
                .init(title: "Переименовать", style: .default, handler: nil, textColor: BaseColor.green500),
                .init(title: "Удалить", style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.sections[indexPath.section].elements.remove(at: indexPath.row)
                    self.view.deleteItemElement(at: indexPath)
                    if self.sections[indexPath.section].elements.isEmpty {
                        self.emptySections()
                    }
                }, textColor: BaseColor.red500),
                .init(title: "Отмена", style: .cancel, handler: nil, textColor: BaseColor.green500)
            ]
        )
    }

    func didSelectSegment(at index: Int) {
        selectedSegmentIndex = index
        index == 0 ? createTranferElements() : createPaymentsElements()
    }

    func swap(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        sections[sourceIndexPath.section].elements.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}
