//
//  PDBCardContainerInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit.UIAlertController

class PDBCardContainerInteractor {
    
    private let type: PDBCardType
    private unowned var view: PDBCardContainerViewInput
    private unowned let logger: BaseLogger
    
    private var sections: [PDBCardContainerTable.Section] = []
    private let keyValueStore = KeyValueStore()
    private var isBlocked: Bool = false
    private var internetPaymentsIncluded: Bool = false
    private var operationNotificationIncluded: Bool = false
    
    init(type: PDBCardType, view: PDBCardContainerViewInput, logger: BaseLogger) {
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
    
    private func getIndexPath(by identifier: PDBCardContainerItemId) -> IndexPath? {
        for (section, element) in sections.enumerated() {
            if let row = element.elements.firstIndex(where: { $0.id == identifier }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    
    func getRequisiteViewModel() -> RequisiteViewModel {
        let viewModel =  RequisiteViewModel(type: .card, sections: [
            .init(id: .card, elements: [RequisitesFieldElement(fieldType: .card, expireDate: "12/24", cardNumber: "0000 0000 0000 0000", CVV: "***")]),
            .init(id: .requisites, title: "Реквизиты счета", elements: [
                .init(fieldType: .requisites, description: "Мусагалиев Алайдар Тимур", title: "ФИО клиента", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "890908405609", title: "ИИН клиента", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "АО Банк Фридом Финанс Казахстан", title: "Бан получатель", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KSNVKZKA", title: "БИК", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KZ123456789012", title: "Номер счета карты KZT (IBAN)", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KZ123456789012", title: "Номер счета карты USD (IBAN)", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KZ123456789012", title: "Номер счета карты EUR (IBAN)", icon: BaseImage.copy.uiImage),
                .init(fieldType: .requisites, description: "KZ123456789012", title: "Номер счета карты RUB (IBAN)", icon: BaseImage.copy.uiImage)
            ])
        ])
        
        return viewModel
    }
}

extension PDBCardContainerInteractor: PDBCardContainerInteractorInput {
    
    func getItemBy(indexPath: IndexPath) -> PDBCardContainerFieldElement<PDBCardContainerItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }
    
    func getItemCountIn(section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func getSectionCount() -> Int {
        return sections.count
    }
    
    func getSectiontBy(section: Int) -> PDBCardContainerTable.Section {
        return sections[section]
    }
    
    func createElements() {
        sections += [
            .init(id: .pdBanner, elements: [
                PDBCardContainerFieldElement(
                    id: .pdBanner,
                    title: "",
                    filedType: .pdBanner(items: [
                        PDBannerViewModel(title: "Реквизиты карты", subtitle: "4400 ** 3097"),
                        PDBannerViewModel(title: "Реквизиты карты", subtitle: "4400 ** 3097"),
                        PDBannerViewModel(title: "Реквизиты карты", subtitle: "4400 ** 3097")
                    ])
                )
            ])
        ]
        
        sections += [
            .init(id: .recentOperations, title: "Последние операции",
                  elements: [
                    PDBCardContainerFieldElement(
                        id: .pdItem,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -1000.56, currency: .KZT),
                        caption: "Freedom Card",
                        filedType: .recentOperations
                    ),
                    PDBCardContainerFieldElement(
                        id: .pdItem,
                        image: BaseImage.pdTransfer.uiImage,
                        title: "Перевод на карту",
                        subtitle: "Перевод",
                        amount: Balance(amount: -100.56, currency: .KZT),
                        caption: "Freedom Card",
                        filedType: .recentOperations
                    ),
                    PDBCardContainerFieldElement(
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
        
        if type == .children {
            sections += [
                .init(id: .settings, title: "Настройки",
                      elements: [
                        PDBCardContainerFieldElement(
                            id: .pdOperationNotifications,
                            image: BaseImage.profile_notification.uiImage,
                            title: "Оповещение об операциях",
                            filedType: .switcher(isOn: operationNotificationIncluded)
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdLock,
                            image: BaseImage.pdLock.uiImage,
                            title: "Заблокировать",
                            filedType: .switcher(isOn: isBlocked)
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdLimits,
                            image: BaseImage.pdLimits.uiImage,
                            title: "Лимиты",
                            filedType: .accessory
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdAutoTopup,
                            image: BaseImage.pdReplenishment.uiImage,
                            title: "Автопополнение на карту",
                            filedType: .accessory
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdPlastic,
                            image: BaseImage.pdPlastic.uiImage,
                            title: "Заказать пластиковую карту",
                            filedType: .accessory
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdChangePin,
                            image: BaseImage.pdChangePin.uiImage,
                            title: "Изменить ПИН-код",
                            filedType: .accessory
                        )
                      ]
                     )
            ]
        } else {
            sections += [
                .init(id: .settings, title: "Настройки",
                      elements: [
                        PDBCardContainerFieldElement(
                            id: .pdLock,
                            image: BaseImage.pdLock.uiImage,
                            title: "Заблокировать",
                            filedType: .switcher(isOn: isBlocked)
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdInternetPayments,
                            image: BaseImage.pdInternetPayments.uiImage,
                            title: "Интернет-платежи",
                            subtitle: "Включает Apple Pay",
                            filedType: .switcher(isOn: internetPaymentsIncluded)
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdFavorites,
                            image: BaseImage.pdFavorites.uiImage,
                            title: "Основная карта",
                            subtitle: "Для получения переводов по ном. телефона",
                            filedType: .switcher(isOn: true),
                            isEnabled: false
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdLimits,
                            image: BaseImage.pdLimits.uiImage,
                            title: "Лимиты",
                            filedType: .accessory
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdChangePin,
                            image: BaseImage.pdChangePin.uiImage,
                            title: "Изменить ПИН-код",
                            filedType: .accessory
                        ),
                        PDBCardContainerFieldElement(
                            id: .pdPlastic,
                            image: BaseImage.pdPlastic.uiImage,
                            title: "Заказать пластиковую карту",
                            filedType: .accessory
                        ),
                        PDBCardContainerFieldElement(
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
                    PDBCardContainerFieldElement(
                        id: .pdReferences,
                        image: BaseImage.pdReferences.uiImage,
                        title: "Справки",
                        subtitle: "О наличии счета и доступном остатке",
                        filedType: .accessory
                    ),
                    PDBCardContainerFieldElement(
                        id: .pdConditions,
                        image: BaseImage.pdConditions.uiImage,
                        title: "Условия карты".localized,
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
        case .pdLimits:
            view.routeToLimits()
        case .pdPlastic:
            view.routeToOrder(type: .order)
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
        case .pdOperationNotifications:
            operationNotificationIncluded = isOn
            view.showAlertOnTop(withMessage: isOn ? "Уведомления включены" : "Уведомления отключены", lottie: nil)
            sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: operationNotificationIncluded)
        default: break
        }
    }
    
    func didSelectItemBanner(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            view.routeToIncomeCard()
        } else {
            view.routeToRequsites(viewModel: getRequisiteViewModel())
        }
    }
}

extension PDBCardContainerInteractor: ChangePhoneDelegate {
    
    func confirm() {
        view.showAlertOnTop(withMessage: "Код доступа изменен".localized, lottie: nil)
        
        view.showAlertOnTop(withMessage: "Номер изменен".localized, lottie: nil)
    }
}

extension PDBCardContainerInteractor: AddEmailDelegate {
    
    func confirmAddEmail() {
        view.showAlertOnTop(withMessage: "Email изменен".localized, lottie: nil)
    }
}
