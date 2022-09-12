//
//  HomeInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

class HomeInteractor {

    private var sections: [HomeTable.Section] = []
    private var view: HomeViewInput

    init(view: HomeViewInput) {
        self.view = view
    }
    
    func getItemBy(indexPath: IndexPath) -> HomeFieldItemElement? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }
}

extension HomeInteractor: BottomSheetPickerViewDelegate {
    
    func didSelect(index: Int, id: UUID) {
        if index == 2 {
            view.routeToDeposit()
        } else if index == 1 {
            view.routeToJuniorCardPresentation()
        } else {
            view.routeToOpenInvestCard()
        }
    }
}

extension HomeInteractor: HomeInteractorInput {
    func createElements() {
        sections += [
            .init(id: .story, elements: [.init(fieldType: .story(items: [], shimmer: true))])
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.sections[0].elements[0].fieldType = .story(items: [
                BaseImage.home_story_1,
                BaseImage.home_story_2,
                BaseImage.home_story_3,
                BaseImage.home_story_4,
                BaseImage.home_story_1,
                BaseImage.home_story_2,
                BaseImage.home_story_3
            ])
            
            self.sections += [
                .init(id: .widgets, elements: [
                    .init(title: "", fieldType: .widgets(items: [
                        WidgetViewModel(
                            title: "Траты за апрель",
                            amount: "10 000,21 ₸",
                            type: .expense([
                                ExpenseModel(partition: 100, color: BaseColor.blue300),
                                ExpenseModel(partition: 210, color: BaseColor.green500),
                                ExpenseModel(partition: 300, color: BaseColor.yellow500),
                                ExpenseModel(partition: 50, color: BaseColor.pink300),
                            ])
                        ),
                        WidgetViewModel(
                            title: "Ежемесячный платеж до 18 апреля",
                            amount: "12 450,00 ₸",
                            type: .credit(buttonTitle: "Погасить")
                        ),
                        WidgetViewModel(
                            title: "Freedom Holdi...",
                            subtitle: "Накоплено акций",
                            icon: BaseImage.freedomStocks.uiImage,
                            amount: "$59,89",
                            type: .stocks(stockCount: "2,83",
                                          stockStatus: "+0,89 (1,51 %) ↑",
                                          sctockShortTitle: "FRHC")
                        )
                    ]))
                ])
            ]
            self.view.reload()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.sections += [
                .init(id: .cards,
                      title: "Карты",
                      footer: "Открыть новую карту",
                      elements: [
                        .init(
                            icon: .cardMiniatureMaster,
                            title: "Freedom Card",
                            fieldType: .card(.freedom),
                            description: "Мультивалютная ** 3097 ",
                            amount: Balance(amount: 0.56, currency: .KZT),
                            connectedToApplePay: true
                        ),
                        .init(
                            icon: .freedomCard,
                            title: "Invest Card",
                            fieldType: .card(.invest),
                            description: "Кредитная ** 3031",
                            amount: Balance(amount: 1000.56, currency: .USD)
                        ),
                        .init(
                            icon: .investCard,
                            title: "Invest Card",
                            fieldType: .card(.invest),
                            description: "Инвестиционная ** 3097",
                            amount: Balance(amount: 6969, currency: .USD),
                            isActive: false
                        ),
                        .init(
                            icon: .freepayCard,
                            title: "Freedom Card",
                            fieldType: .card(.children),
                            description: "Детская карта ** 9669",
                            amount: Balance(amount: -190.56, currency: .RUB),
                            isActive: false
                        )
                      ]),
                .init(id: .deposits,
                      title: "Депозиты",
                      footer: "Открыть новый депозит",
                      elements: [
                        .init(
                            icon: DCAProductType.deposit.icon,
                            title: "Капитал",
                            fieldType: .deposit(.capital),
                            description: "** 4129",
                            amount: Balance(amount: 8751000.42, currency: .KZT)
                        ),
                        .init(
                            icon: DCAProductType.deposit.icon,
                            title: "Стратегия",
                            fieldType: .deposit(.strategy),
                            description: "** 4129",
                            amount: Balance(amount: 9999, currency: .KZT)
                        ),
                        .init(
                            icon: DCAProductType.deposit.icon,
                            title: "Копилка",
                            fieldType: .deposit(.piggyBank),
                            description: "** 4129",
                            amount: Balance(amount: 1042.42, currency: .RUB)
                        ),
                        .init(
                            icon: DCAProductType.deposit.icon,
                            title: "Цифровой",
                            fieldType: .deposit(.digital),
                            description: "** 6969",
                            amount: Balance(amount: 101110.42, currency: .KZT)
                        )
                      ]),
                .init(id: .credits,
                      title: "Кредиты",
                      footer: "Получить кредит",
                      elements: [
                        .init(
                            icon: DCAProductType.credit(type: .credit).icon,
                            title: "Кредит",
                            fieldType: .credit,
                            description: "На 480 000₸",
                            amount: Balance(amount: 21930.00, currency: .KZT),
                            maturityDate: "до 17 апреля"
                        ),
                        .init(
                            icon: DCAProductType.credit(type: .mortgage).icon,
                            title: "Ипотека",
                            fieldType: .credit,
                            description: "На 25 000 000₸",
                            amount: Balance(amount: 179420.00, currency: .KZT),
                            maturityDate: "до 21 апреля"
                        ),
                        .init(
                            icon: DCAProductType.credit(type: .carLoan).icon,
                            title: "Автокредит",
                            fieldType: .credit,
                            description: "На 10 000 000₸",
                            amount: Balance(amount: 79420.00, currency: .KZT),
                            maturityDate: "до 25 апреля"
                        ),
                      ]),
                .init(id: .accounts,
                      title: "Счета",
                      footer: "Открыть новый счет",
                      elements: [
                        .init(
                            icon: DCAProductType.account(currency: .KZT).icon,
                            title: "Текущий",
                            fieldType: .account,
                            description: "**7890",
                            amount: Balance(amount: -21930.00, currency: .KZT)
                        ),
                        .init(
                            icon: DCAProductType.account(currency: .USD).icon,
                            title: "Текущий",
                            fieldType: .account,
                            description: "**7890",
                            amount: Balance(amount: 1930.00, currency: .USD),
                            isActive: false,
                            showSeparator: false
                        )
                ]),
                .init(id: .offers, elements: [
                    .init(fieldType: .offers(items: [
                        OffersViewModel(title: "Вам одобрен кредит на сумму 7 000 000 ₸"),
                        OffersViewModel(title: "Депозит онлайн на самых выгодных условиях"),
                        OffersViewModel(title: "Онлайн страховка в один клик")
                    ]))
                ]),
                .init(id: .button, elements: [
                    .init(
                        title: "Открыть новый продукт",
                        fieldType: .button
                    )
                ])
            ]
            self.view.reload()
        }
    }

    func getSectionsCount() -> Int {
        return sections.count
    }

    func getCountBy(section: Int) -> Int {
        let item = sections[section]
        return item.isExpand ? 0 : item.elements.count
    }

    func getSectiontBy(section: Int) -> HomeTable.Section {
        return sections[section]
    }

    func getElementBy(id: IndexPath) -> HomeFieldItemElement {
        return sections[id.section].elements[id.row]
    }
    
    func expand(section: Int) {
        sections[section].isExpand.toggle()
        view.reload()
    }

    func presentOpenCardActions() {
        let cardIcon = BaseImage.openCard.uiImage
        let depositIcon = BaseImage.openDeposit.uiImage
        let creditIcon = BaseImage.getCredit.uiImage

        let moduleItems: [BasePickerPickerItem] = [
            BasePickerPickerItem(image: cardIcon, title: "Открыть карту", description: "Invest Card, FreePay, Детская"),
            BasePickerPickerItem(image: cardIcon, title: "Открыть детскую карту", description: "Invest Card, FreePay, Детская"),
            BasePickerPickerItem(image: depositIcon, title: "Открыть депозит", description: "Цифровой, Копилка, Стратегия, Капитал"),
            BasePickerPickerItem(image: creditIcon, title: "Получить кредит", description: "Цифровой автокредит, Цифровая ипотека")
        ]
        let module = BottomSheetPickerViewController<CardOpenActionsCell>()
        let viewModel = BottomSheetPickerViewModel(title: "Открыть новый продукт", id: UUID(), selectedIndex: -1, items: moduleItems, delegate: self)
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)

        view.presentDocumentList(module: module)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let id = getItemBy(indexPath: indexPath)?.fieldType else { return }
        switch id {
        case .card(let type):
            view.routeToCardDetail(type: type)
        case .account:
            view.routeToAccountDetail()
        case .deposit(let type):
            view.routeToDepositsDetail(type: type)
        default: break
        }
    }
}
