//
//  PDBDepositContainerInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit.UIAlertController

class PDBDepositContainerInteractor {
    
    private let type: PDBDepositType
    private unowned var view: PDBDepositContainerViewInput
    private unowned let logger: BaseLogger
    
    private var sections: [PDBDepositContainerTable.Section] = []
    private let keyValueStore = KeyValueStore()
    private var isBlocked: Bool = false
    private var internetPaymentsIncluded: Bool = false
    
    init(type: PDBDepositType, view: PDBDepositContainerViewInput, logger: BaseLogger) {
        self.type = type
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
    
    private func getIndexPath(by identifier: PDBDepositContainerItemId) -> IndexPath? {
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

extension PDBDepositContainerInteractor: PDBDepositContainerInteractorInput {

    func getItemBy(indexPath: IndexPath) -> PDBDepositContainerFieldElement<PDBDepositContainerItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }
    
    func getItemCountIn(section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func getSectionCount() -> Int {
        return sections.count
    }
    
    func getSectiontBy(section: Int) -> PDBDepositContainerTable.Section {
        return sections[section]
    }
    
    func createElements() {
        sections += [
            .init(id: .remunaration,
                  elements: [
                    PDBDepositContainerFieldElement(
                        id: .remunaration,
                        title: "+22 020,89 ₸",
                        subtitle: "Вознаграждение за весь период",
                        filedType: .remunaration
                    )
                  ]
            )
        ]
        
        if type != .piggyBank {
            sections += [
                .init(id: .recentOperations, title: "Последние операции",
                      elements: [
                        PDBDepositContainerFieldElement(
                            id: .pdItem,
                            image: BaseImage.pdTransfer.uiImage,
                            title: "Перевод на карту",
                            subtitle: "Перевод",
                            amount: Balance(amount: -1000.56, currency: .KZT),
                            caption: "Freedom Card",
                            filedType: .recentOperations
                        ),
                        PDBDepositContainerFieldElement(
                            id: .pdItem,
                            image: BaseImage.pdTransfer.uiImage,
                            title: "Перевод на карту",
                            subtitle: "Перевод",
                            amount: Balance(amount: -100.56, currency: .KZT),
                            caption: "Freedom Card",
                            filedType: .recentOperations
                        ),
                        PDBDepositContainerFieldElement(
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
        }
        
        if type == .digital {
            sections += [
                .init(id: .settings, title: "Настройки",
                      elements: [
                        PDBDepositContainerFieldElement(
                            id: .pdLock,
                            image: BaseImage.pdLock.uiImage,
                            title: "Заблокировать",
                            filedType: .switcher(isOn: isBlocked)
                        ),
                        PDBDepositContainerFieldElement(
                            id: .pdInternetPayments,
                            image: BaseImage.pdInternetPayments.uiImage,
                            title: "Интернет-платежи",
                            subtitle: "Включает Apple Pay",
                            filedType: .switcher(isOn: internetPaymentsIncluded)
                        ),
                        PDBDepositContainerFieldElement(
                            id: .pdLimits,
                            image: BaseImage.pdLimits.uiImage,
                            title: "Лимиты",
                            filedType: .accessory
                        ),
                        PDBDepositContainerFieldElement(
                            id: .pdChangePin,
                            image: BaseImage.pdChangePin.uiImage,
                            title: "Изменить ПИН-код",
                            filedType: .accessory
                        ),
                        PDBDepositContainerFieldElement(
                            id: .pdPlastic,
                            image: BaseImage.pdPlastic.uiImage,
                            title: "Заказать пластиковую карту",
                            filedType: .accessory
                        ),
                        PDBDepositContainerFieldElement(
                            id: .pdCloseCard,
                            image: BaseImage.pdCloseCard.uiImage,
                            title: "Закрыть карту",
                            filedType: .accessory
                        )
                      ]
                )
            ]
        }
        
        sections += [
            .init(id: .settings, title: "Детали",
                  elements: [
                    PDBDepositContainerFieldElement(
                        id: .pdReferences,
                        image: BaseImage.pdReferences.uiImage,
                        title: "Справки",
                        subtitle: "О наличии счета и доступном остатке",
                        filedType: .accessory
                    ),
                    PDBDepositContainerFieldElement(
                        id: .pdConditions,
                        image: BaseImage.pdConditions.uiImage,
                        title: "Условия депозита".localized,
                        filedType: .accessory
                    ),
                    PDBDepositContainerFieldElement(
                        id: .pdRequisites,
                        image: BaseImage.pdReferences.uiImage,
                        title: "Реквизиты".localized,
                        filedType: .accessory
                    ),
                    PDBDepositContainerFieldElement(
                        id: .pdCloseCard,
                        image: BaseImage.pdCloseCard.uiImage,
                        title: "Закрыть депозит".localized,
                        filedType: .accessory
                    )
                  ]
            )
        ]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let id = getItemBy(indexPath: indexPath)?.id else { return }
        switch id {
        case .pdConditions:
            view.routeToConditions()
        case .pdReferences:
            view.routeToReference()
        case .pdRequisites:
            view.routeToRequsites(viewModel: getRequisiteViewModel())
        case .remunaration:
            view.routeToDepositReward()
        default: break
        }
    }
    
    func switcher(isOn: Bool, at indexPath: IndexPath) {
        switch sections[indexPath.section].elements[indexPath.row].id {
        case .pdLock:
            sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: isBlocked)
            view.update(at: indexPath)
            showLockAlert(isOn: isOn, handler: { [weak self] _ in
                guard let self = self else { return }
                self.isBlocked = isOn
                self.view.showAlertOnTop(
                    withMessage: isOn ? "Карта заблокирована".localized : "Карта разблокирована".localized,
                    lottie: nil
                )
                self.sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: isOn)
                self.view.update(at: indexPath)
            })
        case .pdInternetPayments:
            sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: internetPaymentsIncluded)
            view.update(at: indexPath)
            showInternetPaymentAlert(isOn: isOn, handler: { [weak self] _ in
                guard let self = self else { return }
                self.internetPaymentsIncluded = isOn
                self.view.showAlertOnTop(
                    withMessage: isOn ? "Интернет-платежи включены".localized : "Интернет-платежи выключены".localized,
                    lottie: nil
                )
                self.sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: isOn)
                self.view.update(at: indexPath)
            })
        default: break
        }
    }
}

extension PDBDepositContainerInteractor: ChangePhoneDelegate {
    
    func confirm() {
        view.showAlertOnTop(withMessage: "Код доступа изменен".localized, lottie: nil)
        
        view.showAlertOnTop(withMessage: "Номер изменен".localized, lottie: nil)
    }
}

extension PDBDepositContainerInteractor: AddEmailDelegate {
    
    func confirmAddEmail() {
        view.showAlertOnTop(withMessage: "Email изменен".localized, lottie: nil)
    }
}
