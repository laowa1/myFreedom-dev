//
//  PDBAccountContainerInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit.UIAlertController

class PDBAccountContainerInteractor {
    
    private unowned var view: PDBAccountContainerViewInput
    private unowned let logger: BaseLogger
    
    private var sections: [PDBAccountContainerTable.Section] = []
    private let keyValueStore = KeyValueStore()
    private var isBlocked: Bool = false
    private var internetPaymentsIncluded: Bool = false
    
    init(view: PDBAccountContainerViewInput, logger: BaseLogger) {
        self.view = view
        self.logger = logger
    }
    
    private func getEnable(key: KeyValueStore.Key) -> Bool {
        let enable: Bool? = KeyValueStore().getValue(for: key)
        return enable ?? false
    }
    
    private func showAlert(
        title: String?,
        message: String?,
        firstTitle: String = "Отменить",
        secondTitle: String,
        secondHandler: ((UIAlertAction) -> Void)? = nil,
        secondColor: UIColor
    ) {
        view.showAlert(
            title: title,
            message: message,
            first: .init(title: firstTitle, style: .cancel, handler: nil),
            second: .init(title: secondTitle, style: .default, handler: secondHandler),
            secondColor: secondColor
        )
    }
    
    private func showLockAlert(isOn: Bool, handler: ((UIAlertAction) -> Void)? = nil) { //message: String
        if isOn {
            showAlert(
                title: "Вы уверены, что хотите заблокировать карту?",
                message: "Операции по карте будут невозможны",
                secondTitle: "Заблокировать",
                secondHandler: handler,
                secondColor: BaseColor.red500
            )
        } else {
            showAlert(
                title: "Вы уверены, что хотите разблокировать карту?",
                message: "Операции по карте будут снова доступны",
                secondTitle: "Разблокировать",
                secondHandler: handler,
                secondColor: BaseColor.green500
            )
        }
    }
    
    private func showInternetPaymentAlert(isOn: Bool, handler: ((UIAlertAction) -> Void)? = nil) {
        if isOn {
            showAlert(
                title: "Вы уверены, что хотите включить интернет-платежи?",
                message: "Онлайн транзакции будут снова доступны",
                secondTitle: "Включить",
                secondHandler: handler,
                secondColor: BaseColor.green500
            )
        } else {
            showAlert(
                title: "Вы уверены, что хотите отключить интернет-платежи?",
                message: "Онлайн транзакции будут недоступны",
                secondTitle: "Да, отключить",
                secondHandler: handler,
                secondColor: BaseColor.red500
            )
        }
    }
    
    private func getIndexPath(by identifier: PDBAccountContainerItemId) -> IndexPath? {
        for (section, element) in sections.enumerated() {
            if let row = element.elements.firstIndex(where: { $0.id == identifier }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    
    private func getRequisiteViewModel() -> RequisiteViewModel {
        let viewModel =  RequisiteViewModel(type: .card, sections: [
            .init(id: .requisites, title: "Реквизиты счета", elements: [
                .init(fieldType: .requisites, description: "Мусагалиев Алайдар Тимур", title: "ФИО клиента", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "890908405609", title: "ИИН клиента", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "АО Банк Фридом Финанс Казахстан", title: "Бан получатель", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KSNVKZKA", title: "БИК", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KZ123456789012", title: "Номер счета карты KZT (IBAN)", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KZ123456789012", title: "Номер счета карты USD (IBAN)", icon: BaseImage.copy.uiImage)
                ])
        ])

        return viewModel
    }
}

extension PDBAccountContainerInteractor: PDBAccountContainerInteractorInput {

    func getItemBy(indexPath: IndexPath) -> PDBAccountContainerFieldElement<PDBAccountContainerItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }
    
    func getItemCountIn(section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func getSectionCount() -> Int {
        return sections.count
    }
    
    func getSectiontBy(section: Int) -> PDBAccountContainerTable.Section {
        return sections[section]
    }
    
    func createElements() {
        sections += [
            .init(id: .recentOperations, title: "Последние операции",
                  elements: [
                    PDBAccountContainerFieldElement(
                        id: .pdItem,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -1000.56, currency: .KZT),
                        caption: "Freedom Card",
                        filedType: .recentOperations
                    ),
                    PDBAccountContainerFieldElement(
                        id: .pdItem,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -100.56, currency: .KZT),
                        caption: "Freedom Card",
                        filedType: .recentOperations
                    ),
                    PDBAccountContainerFieldElement(
                        id: .pdItem,
                        image: BaseImage.pdReplenishment.uiImage,
                        title: "Пополнение депозита",
                        subtitle: "Пополнение",
                        amount: Balance(amount: 1100.56, currency: .KZT),
                        caption: "Freedom Card",
                        showSeparator: false,
                        filedType: .recentOperations
                    )
                  ]
            )
        ]
        
        sections += [
            .init(id: .settings, title: "Детали",
                  elements: [
                    PDBAccountContainerFieldElement(
                        id: .pdRequisites,
                        image: BaseImage.pdReferences.uiImage,
                        title: "Реквизиты".localized,
                        filedType: .accessory
                    ),
                    PDBAccountContainerFieldElement(
                        id: .pdReferences,
                        image: BaseImage.pdReferences.uiImage,
                        title: "Справки",
                        subtitle: "О наличии счета и доступном остатке",
                        filedType: .accessory
                    )
                  ]
            )
        ]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let id = getItemBy(indexPath: indexPath)?.id else { return }
        switch id {
        case .pdReferences:
            view.routeToReference()
        case .pdRequisites:
            view.routeToRequsites(viewModel: getRequisiteViewModel())
        default: break
        }
    }
}

extension PDBAccountContainerInteractor: ChangePhoneDelegate {
    
    func confirm() {
        view.showAlertOnTop(withMessage: "Код доступа изменен".localized, lottie: nil)
        
        view.showAlertOnTop(withMessage: "Номер изменен".localized, lottie: nil)
    }
}

extension PDBAccountContainerInteractor: AddEmailDelegate {
    
    func confirmAddEmail() {
        view.showAlertOnTop(withMessage: "Email изменен".localized, lottie: nil)
    }
}
