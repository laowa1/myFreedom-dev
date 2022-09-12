//
//  DepositSelectedInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

enum DepositSelectedType: CaseIterable {
    case deposit, calculator

    var title: String {
        switch self {
        case .deposit: return "Депозиты"
        case .calculator: return "Калькулятор"
        }
    }
}

class DepositSelectedInteractor {

    private class var types: [DepositSelectedType] { DepositSelectedType.allCases }
    private var sections: [OPElement.Section] = []
    private var view: DepositSelectedViewInput
    private var selectedSegmentIndex = 0

    init(view: DepositSelectedViewInput) {
        self.view = view
    }
}

extension DepositSelectedInteractor: DepositSelectedInteractorInput {

    func getCountBy(section: Int) -> Int {
        return sections[safe: section]?.elements.count ?? 0
    }

    func getSectiontBy(section: Int) -> OPElement.Section {
        return sections[section]
    }

    func getElementBy(indexPath: IndexPath) -> OPFieldItemElement<OPItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }

    func generateInital() {
        view.pass(segmentTitles: Self.types.map { $0.title })
        createTranferElements()
    }

    func createTranferElements() {
        sections = [
            .init(id: .deposit,
                  elements: [
                    OPFieldItemElement(
                        id: .depositInfo,
                        title: "Цифровой",
                        subtitle: "• Ежедневное начисление и своя депозитная карта \n• C пополнением и частичным снятием",
                        fieldType: .depositInfo([
                            DepositItem(currency: .KZT, term: "до 13.5%"),
                            DepositItem(currency: .USD, term: "1%"),
                            DepositItem(currency: .EUR, term: "0.8%"),
                            DepositItem(currency: .RUB, term: "1%")
                        ])
                    ),
                    OPFieldItemElement(
                        id: .depositInfo,
                        title: "Копилка",
                        subtitle: "• С пополнением и частичным снятием\n• Сумма от 15 000 ₸ / 100$ / 100€ / 3 000 ₽",
                        fieldType: .depositInfo([
                            DepositItem(currency: .KZT, term: "до 13.5%"),
                            DepositItem(currency: .USD, term: "1%"),
                            DepositItem(currency: .EUR, term: "0.8%"),
                            DepositItem(currency: .RUB, term: "1%")
                        ])
                    ),
                    OPFieldItemElement(
                        id: .depositInfo,
                        title: "Стратегия",
                        subtitle: "• C пополнением, но без снятия\n• Сумма от 15 000 ₸ / 100$",
                        fieldType: .depositInfo([
                            DepositItem(currency: .KZT, term: "до 13.5%"),
                            DepositItem(currency: .USD, term: "1%")
                        ])
                    ),
                    OPFieldItemElement(
                        id: .depositInfo,
                        title: "Капитал",
                        subtitle: "• Без снятия и без пополнения\n• Сумма от 500 000 ₸",
                        fieldType: .depositInfo([
                            DepositItem(currency: .KZT, term: "до 14.8%")
                        ])
                    )
                  ]
            )
        ]
        view.reload()
    }

    func createPaymentsElements() {
        sections = [
            .init(id: .calculator,
                  elements: [
                    OPFieldItemElement(
                        id: .depositType,
                        title: "Вид депозита",
                        fieldType: .depositType([
                                    SelectionItemModel(title: "Цифровой", isSelected: true),
                                    SelectionItemModel(title: "Копилка"),
                                    SelectionItemModel(title: "Стратегия"),
                                    SelectionItemModel(title: "Капитал")
                        ])
                    ),
                    OPFieldItemElement(
                        id: .depositType,
                        title: "На срок",
                        fieldType: .depositType([
                            SelectionItemModel(title: "36 мес", isSelected: true)
                        ])
                    ),
                    OPFieldItemElement(
                        id: .iWantToInvest,
                        title: "Хочу вложить",
                        subtitle: "от 0, 1 €",
                        fieldType: .input(.iWantToInvest)
                    ),
                    OPFieldItemElement(
                        id: .iWantToInvest,
                        title: "Ежемесячно буду пополнять",
                        subtitle: "0 €",
                        fieldType: .input(.iWillReplenishItMonthly)
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

    func didSelectSegment(at index: Int) {
        selectedSegmentIndex = index
        index == 0 ? createTranferElements() : createPaymentsElements()
    }
}
