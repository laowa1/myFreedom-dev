//
//  ChangePhoneNumberInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.04.2022.
//

import OZLivenessSDK
import UIKit.UIViewController

class ChangePhoneNumberInteractor {

    private unowned var view: ChangePhoneNumberViewInput?
    private weak var delegate: ChangePhoneDelegate?
    private let isHiddenBack: Bool
    private var phone: String?
    private let idSIVIIN = UUID()
    private let idNotFound = UUID()
    private let idFound = UUID()

    private let idNotAccept = UUID()
    private let idRepeat = UUID()
    private let idFoundIdentity = UUID()

    init(
        view: ChangePhoneNumberViewInput,
        delegate: ChangePhoneDelegate?,
        isHiddenBack: Bool,
        phone: String?
    ) {
        self.view = view
        self.delegate = delegate
        self.isHiddenBack = isHiddenBack
        self.phone = phone
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
}


extension ChangePhoneNumberInteractor: ChangePhoneNumberInteractorInput {

    func checkingPhoneNumber(phone: String) {
        guard let id = [idFound, idNotFound].randomElement() else { return }
        view?.routeToVerification(phone: phone, id: delegate == nil ? id : idFound)
    }

    func openEnterIIN() {
        view?.routeToEnterIIN(delegate: self, id: idSIVIIN)
    }

    func validate(with id: UUID) {
        switch id {
        case idFound:
            openIdentity()
        case idNotFound:
            openEnterIIN()
        default:
            break
        }
    }

    func isHiddenBackButton() -> Bool { isHiddenBack }

    func validatePhone() {
        guard let phone = phone else { return }
        checkingPhoneNumber(phone: phone)
    }
}

extension ChangePhoneNumberInteractor: SIVConfirmButtonDelegate {

    func confirmButtonAction(text: String, id: UUID) {
        switch id {
        case idSIVIIN:
            openIdentity()
        default: break
        }
    }
}

extension ChangePhoneNumberInteractor: InformPUButtonDelegate {

    func buttonPressed(type: InformPUButtonType, id: UUID) {
        switch id {
        case idFoundIdentity:
            openLiveness()
        case idNotAccept:
            openLiveness()
        case idRepeat:
            view?.routeToComeUpCode()
        default: break
        }
    }
}

extension ChangePhoneNumberInteractor: OZLivenessDelegate {
    func onOZLivenessResult(results: [Media]) {
        view?.routeToLoader()
    }

    func onError(status: OZVerificationStatus?) {
        openNotAcceptBank()
    }
}
