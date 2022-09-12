//
//  PDLimitsInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import Foundation

class PDLimitsInteractor {

    private var items: [PDLimitsElement] = []
    private var view: PDLimitsViewInput

    init(view: PDLimitsViewInput) {
        self.view = view
    }
}

extension PDLimitsInteractor: PDLimitsInteractorInput {
    
    func createElements() {
        items += [
            .init(
                title: "Интернет-платежи отключены",
                amount: Balance(amount: 500000, currency: .KZT),
                usedUp: Balance(amount: 0, currency: .KZT),
                alertTitle: "Вы уверены, что хотите включить интернет-платежи?",
                alertSubtitle: "Онлайн транзакции будут снова доступны",
                isActive: false
            ),
            .init(
                title: "На снятие наличных",
                amount: Balance(amount: 300000, currency: .KZT),
                usedUp: Balance(amount: 0, currency: .KZT),
                alertTitle: "Вы уверены, что хотите включить снятие наличных?",
                alertSubtitle: "Cнятие наличных будут снова доступны",
                isActive: true
            ),
            .init(
                title: "На снятие наличных",
                amount: Balance(amount: 300000, currency: .KZT),
                usedUp: Balance(amount: 0, currency: .KZT),
                alertTitle: "Вы уверены, что хотите включить снятие наличных?",
                alertSubtitle: "Cнятие наличных будут снова доступны",
                isActive: true
            )
        ]
        view.reloadData()
    }
    
    func getItemsCount() -> Int {
        return items.count
    }
    
    func getItemsElementBy(id: IndexPath) -> PDLimitsElement {
        return items[id.row]
    }
    
    func showAlert(index: IndexPath) {
        guard let item = items[safe: index.row] else { return }
        view.showAlert(
            title: item.alertTitle,
            message: item.alertSubtitle,
            first: .init(title: "Отменить", style: .cancel),
            second: .init(title: "Включить", style: .default, handler: { [weak self] _ in
                self?.view.showAlertOnTop(withMessage: "Интернет-платежи включены", lottie: nil)
            })
        )
    }
    
    func expand(section: Int) { }

    func presentInfoBS() {
        let moduleItems = [
            PDLimitsInfoItem(description: "На снятие наличных: До 500 000 тг снятие без комиссии в этом месяце."),
            PDLimitsInfoItem(description: "При снятии сверх лимита взымается комиссия n% от суммы превышения.")
        ]
        let module = BottomSheetPickerViewController<PDLimitsInfoCell>()
        let viewModel = BottomSheetPickerViewModel(title: "Лимит на снятие наличных", id: UUID(), selectedIndex: -1, items: moduleItems, delegate: self)
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)

        view.presentBottomSheet(module: module)
    }
}

extension PDLimitsInteractor: BottomSheetPickerViewDelegate {
        
    func didSelect(index: Int, id: UUID) {
        switch id {
//        case Id:
        default: break
        }
    }
}
