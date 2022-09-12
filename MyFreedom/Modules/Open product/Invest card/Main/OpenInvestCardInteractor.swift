//
//  CHCPresentationInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//

import Foundation
import OZLivenessSDK
import UIKit.UIViewController

protocol OpenInvestCardInteractorInput {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getElementBy(id: IndexPath) -> OpenInvestCardFieldItemElement
    func getSectiontBy(section: Int) -> OpenInvestCardTable.Section
    func getTermsString() -> NSAttributedString
    func createElements()
    func openOtp()
    func validate(with id: UUID)
    func checkingInDatabases()
}

class OpenInvestCardInteractor {

    private var view:OpenInvestCardViewInput?
    private var sections = [OpenInvestCardTable.Section]()
    private let idSIVIIN = UUID()
    private let idNotFound = UUID()
    private let idFound = UUID()

    private let idNotAccept = UUID()
    private let idRepeat = UUID()
    private let idFoundIdentity = UUID()
    private let idCardIssue = UUID()
    private let idYourIdCardIsExpired = UUID()
    private let idYouDonHaveABrokerageAccount = UUID()

    init(view: OpenInvestCardViewInput) {
        self.view = view
    }

    private func openIdentity() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Пройдите видео проверку"),
            subtitleText: "Убедитесь, что ваше лицо освещено, и держите камеру на уровне глаз",
            image: .binoculars,
            buttons: [.init(type: .confirm, title: "Начать видео проверку", isGreen: true)],
            hiddenBack: false,
            id: idFoundIdentity
        )
        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }

    private func openNotAcceptBank() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Что-то пошло не так"),
            subtitleText: "Пожалуйста, обратитесь в Отделение банка",
            image: .bell,
            buttons: [.init(type: .confirm, title: "Вернуться в начало", isGreen: true)],
            hiddenBack: false,
            id: idNotAccept
        )
        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }

    private func openRepeat() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Что-то пошло не так"),
            subtitleText: "Пожалуйста, повторите видео проверку",
            image: .bell,
            buttons: [.init(type: .confirm, title: "Повторить видео проверку", isGreen: true)],
            hiddenBack: false,
            id: idRepeat
        )
        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }

    private func openLiveness() {
//            let allActions: [OZVerificationMovement] = [.close, .eyes, .up, .down, .left, .right, .selfie]
        let actions: [OZVerificationMovement] = [.scanning, .smile, .far]
        do {
            let ozLivenessVC: UIViewController = try OZSDK.createVerificationVCWithDelegate(self, actions: actions, cameraPosition: .front)
            view?.present(ozLivenessVC, animated: true)
        } catch {
            print(error)
            openNotAcceptBank()
        }
    }

    private func openYourIdCardIsExpired() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Ваше удостоверение просрочено"),
            subtitleText: "Обновите удостоверение и попробуйте снова",
            image: .bell,
            buttons: [.init(type: .destructive, title: "Вернуться на Главную", isGreen: true)],
            hiddenBack: false,
            id: idYourIdCardIsExpired
        )
        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }

    private func cardIssue() {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: BaseFont.bold.withSize(28),
            .foregroundColor: BaseColor.base900
        ]
        let attrs1: [NSAttributedString.Key: Any] = [
            .font: BaseFont.bold.withSize(28),
            .foregroundColor: BaseColor.green500
        ]
        let mainText = NSMutableAttributedString(string: "Ваша", attributes: attrs)
        mainText.append(NSAttributedString(string: " INVEST CARD ", attributes: attrs1))
        mainText.append(NSAttributedString(string: "почти готова!", attributes: attrs))
        let model = InformPUViewModel(
            titleText: mainText,
            subtitleText: "Это цифровая карта. Вы можете заказать пластиковую на странице карты",
            image: .yourFreedomCardIsReady,
            buttons: [
                .init(type: .confirm, title: "Перейти на страницу карты", isGreen: true),
                .init(type: .cancel, title: "Вернуться на Главную", isGreen: false)
            ],
            id: idCardIssue
        )
        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }

    private func youDonHaveABrokerageAccount() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Алайдар, у вас нет брокерского счета"),
            subtitleText: "Открывая INVEST Card, вы открываете брокерский счет в компании Freedom Finance Global PLC. Мы откроем счет в течение двух минут. Пожалуйста, нажмите кнопку Продолжить.",
            image: .yourFreedomCardIsReady,
            buttons: [.init(type: .confirm, title: "Продолжить", isGreen: true)],
            hiddenBack: false,
            id: idYouDonHaveABrokerageAccount
        )
        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }
}

extension OpenInvestCardInteractor: OpenInvestCardInteractorInput {

    func getSectionsCount() -> Int {
        sections.count
    }

    func getCountBy(section: Int) -> Int {
        sections[section].elements.count
    }

    func getElementBy(id: IndexPath) -> OpenInvestCardFieldItemElement {
        sections[id.section].elements[id.row]
    }

    func getSectiontBy(section: Int) -> OpenInvestCardTable.Section {
        sections[section]
    }

    func getTermsString() -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "Продолжая, вы принимаете")
        attrString.append(NSAttributedString(string: " условия банка", attributes: [.foregroundColor: BaseColor.green500]))

        return attrString
    }

    func createElements() {
        sections += [
            .init(id: .card, elements: [
                .init(image: BaseImage.openInvest.uiImage, fieldType: .card)
            ]),

            .init(id: .features, elements: [
                .init(image: BaseImage.openInvestCard2.uiImage, title: "3% годовых — ежедневное начисление дохода в USD", fieldType: .features, description: "На остаток D-счёта от Freedom Finance Global PLC.")
            ]),
            .init(id: .features, elements: [
                .init(image: BaseImage.openInvestCard3.uiImage, title: "3% годовых — ежедневное начисление дохода в USD", fieldType: .features, description: "На остаток D-счёта от Freedom Finance Global PLC.")
            ]),
            .init(id: .rates, title: "Тарифы карты", elements: [
                .init(title: "0 ₸", fieldType: .rate, description: "Выпуск и доставка"),
                .init(title: "0 ₸", fieldType: .rate, description: "Годовое обслуживание"),
                .init(title: "0 ₸", fieldType: .rate, description: "Пополнение со счетов и карт Freedom Finance Bank и карт других банков РК*"),
                .init(title: "3 %", fieldType: .rate, description: "Годовых ежедневное начисление дохода на остаток D-счёта в USD от Freedom Finance Global PLC"),
                .init(title: "3 %", fieldType: .rate, description: "Обналичивание в банкоматах и кассах любого банка РК, переводы на карту или счета любого банка РК, SWIFT-переводы в USD"),
                .init(fieldType: .rateInfo, description: "* У других банков может быть своя комиссия за переводы. Смотрите тарифы на их сайтах")
            ]),

            .init(id: .button, elements: [
                .init(title: "Открыть Invest Card", fieldType: .button)
            ])
        ]

        view?.reload()
    }

    func openOtp() {
        view?.routeToOtp(phone: "+7 747 462 62 15")
    }

    func validate(with id: UUID) {
        openIdentity()
    }

    func checkingInDatabases() {
        if Bool.random() {
            youDonHaveABrokerageAccount()
        } else {
            Bool.random() ? openYourIdCardIsExpired() : cardIssue()
        }
    }
}

extension OpenInvestCardInteractor: InformPUButtonDelegate {

    func buttonPressed(type: InformPUButtonType, id: UUID) {
        switch id {
        case idFoundIdentity:
            openLiveness()
        case idNotAccept:
//            because oz not working
//            openLiveness()
            view?.routeToLoader()
        case idRepeat:
            print(12567654)
        case idCardIssue:
            type == .confirm ? view?.popToRootShowInvestCard() : view?.routeToBack()
        case idYourIdCardIsExpired, idYouDonHaveABrokerageAccount:
            view?.routeToBack()
        default: break
        }
    }
}

extension OpenInvestCardInteractor: OZLivenessDelegate {
    
    func onOZLivenessResult(results: [Media]) {
        view?.routeToLoader()
    }

    func onError(status: OZVerificationStatus?) {
        openNotAcceptBank()
    }
}
