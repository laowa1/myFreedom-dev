//
//  JCLInteractor.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import Foundation

class JCLInteractor {
    
    private lazy var model: JCLModel = createModel()
    private var blockedPayments: [JCLPayments] = []
    private var sections: [JCLContainerTable.Section] = []
    private var view: JCLViewInput
    
    init(view: JCLViewInput) {
        self.view = view
    }
    
    private func createModel() -> JCLModel {
        return JCLModel(
            limits: [
                JCLModel.Limits(id: .withdraw, limit: 500_000, usedUp: 0, period: .month),
                JCLModel.Limits(id: .internetPayments, limit: 500_000, usedUp: 0, period: .month),
                JCLModel.Limits(id: .transfer, limit: 500_000, usedUp: 0, period: .month)
            ],
            blockedPayments: [],
            currencies: [
                JCLModel.Currencies(currencyType: .KZT, isEnabled: true),
                JCLModel.Currencies(currencyType: .USD, isEnabled: true),
                JCLModel.Currencies(currencyType: .EUR, isEnabled: true),
                JCLModel.Currencies(currencyType: .RUB, isEnabled: true)
            ]
        )
    }
    
    
}

extension JCLInteractor: JCLInteractorInput {
    
    func createElements() {
        sections += [
            .init(id: .limits,
                  limits: [
                    PDLimitsElement(title: "На снятие наличных",
                                    amount: Balance(amount: model.limits.first(where: { $0.id == .withdraw })?.limit ?? 0, currency: .KZT),
                                    usedUp: Balance(amount: model.limits.first(where: { $0.id == .withdraw })?.usedUp ?? 0, currency: .KZT)
                                   ),
                    PDLimitsElement(title: "На покупки в интернете",
                                    amount: Balance(amount: model.limits.first(where: { $0.id == .internetPayments })?.limit ?? 0, currency: .KZT),
                                    usedUp: Balance(amount: model.limits.first(where: { $0.id == .internetPayments })?.usedUp ?? 0, currency: .KZT)
                                   ),
                    PDLimitsElement(title: "На переводы",
                                    amount: Balance(amount: model.limits.first(where: { $0.id == .transfer })?.limit ?? 0, currency: .KZT),
                                    usedUp: Balance(amount: model.limits.first(where: { $0.id == .transfer })?.usedUp ?? 0, currency: .KZT)
                                   )
                  ]
                 )
        ]
        
        sections += [
            .init(id: .blockedPayments,
                  title: "Заблокированные платежи"
                 )
        ]
        
        sections += [
            .init(id: .currencies,
                  header: "Валюты для пользования",
                  currencies: [
                    JCLModel.Currencies(currencyType: .KZT, isEnabled: true),
                    JCLModel.Currencies(currencyType: .USD, isEnabled: true),
                    JCLModel.Currencies(currencyType: .EUR, isEnabled: true),
                    JCLModel.Currencies(currencyType: .RUB, isEnabled: true)
                  ]
                 )
        ]
    }
    
    func getBlockedPaymentsCount() -> Int {
        return blockedPayments.count
    }
    
    func getSectionCount() -> Int {
        return sections.count
    }
    
    func getItemCountIn(section: Int) -> Int {
        switch sections[section].id {
        case.limits:
            return sections.first { $0.id == .limits }?.limits?.count ?? 0
        case .blockedPayments:
            return 1
        case .currencies:
            return sections.last?.currencies?.count ?? 0
        }
    }
    
    func getItem(section: Int) -> JCLContainerTable.Section {
        return sections[section]
    }
    
    func presentLimitInfo() {
        let moduleItems = [
            PDLimitsInfoItem(description: "На снятие наличных: До 500 000 тг снятие без комиссии в этом месяце."),
            PDLimitsInfoItem(description: "При снятии сверх лимита взымается комиссия n% от суммы превышения.")
        ]
        let module = BottomSheetPickerViewController<PDLimitsInfoCell>()
        let viewModel = BottomSheetPickerViewModel(title: "Лимит на снятие наличных", id: UUID(), selectedIndex: -1, items: moduleItems, delegate: self)
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)

        view.presentBottomSheet(module: module)
    }
    
    func switcher(isOn: Bool, at indexPath: IndexPath) {
        sections[indexPath.section].currencies?[indexPath.row].isEnabled = isOn
        view.update(at: indexPath)
    }
}

extension JCLInteractor: BottomSheetPickerViewDelegate {
    
    func didSelect(index: Int, id: UUID) {
        switch id {
        default: break
        }
    }
}
