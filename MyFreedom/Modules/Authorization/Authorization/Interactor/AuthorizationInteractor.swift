//
//  AuthorizationInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.04.2022.
//

import Foundation
import UIKit
import OZLivenessSDK

class AuthorizationInteractor {
    
    private unowned var view: AuthorizationViewInput?
    private unowned let logger: BaseLogger
    var agreementSelected: Bool = true {
        didSet {
            view?.agreement(isSelected: agreementSelected)
        }
    }
    private let isHiddenBack: Bool
    private var phone: String?
    private let idSIVIIN = UUID()
    private let idNotFound = UUID()
    private let idFound = UUID()

    private let idNotAccept = UUID()
    private let idRepeat = UUID()
    private let idFoundIdentity = UUID()
    
    init(view: AuthorizationViewInput, logger: BaseLogger, isHiddenBack: Bool, phone: String?) {
        self.view = view
        self.logger = logger
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

extension AuthorizationInteractor: AuthorizationInteractorInput {
    
    func getAgreementModel() -> AgreementSVModel {
        let mainTextAttrs: [NSAttributedString.Key: Any] = [.font: BaseFont.regular.withSize(14),
                                                            .foregroundColor: BaseColor.base400]
        let bankConditionsAttrs: [NSAttributedString.Key: Any] = [.font: BaseFont.medium.withSize(14),
                                                                  .foregroundColor: BaseColor.green500]
        let persinalInfoAttrs: [NSAttributedString.Key: Any] = [.font: BaseFont.medium.withSize(14),
                                                                .foregroundColor: BaseColor.base700]
        
        let mainText = NSMutableAttributedString(string: "Продолжая, вы соглашаетесь с ", attributes: mainTextAttrs)
        mainText.append(NSAttributedString(string: "условиями Банка ", attributes: bankConditionsAttrs))
        mainText.append(NSAttributedString(string: "и подтверждаете, что ", attributes: mainTextAttrs))
        mainText.append(NSAttributedString(string: "не являетесь налогоплательщиком США ", attributes: persinalInfoAttrs))
        mainText.append(NSAttributedString(string: "и будете ", attributes: mainTextAttrs))
        mainText.append(NSAttributedString(string: "бенефициарным владельцем счета.", attributes: persinalInfoAttrs))
        
        return AgreementSVModel(text: mainText, isSelected: true, delegate: self)
    }

    func checkingPhoneNumber(phone: String) {
        guard let id = [idFound, idNotFound].randomElement() else { return }
        view?.routeToVerification(phone: phone, id: id)
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
    
    func testLog() {
        logger.sendAnalyticsEvent(event: "Test", with: ["Test":"123"])
    }
}

extension AuthorizationInteractor: BottomSheetPickerViewDelegate {

    func didSelect(index: Int, id: UUID) {
        guard let url = URL(string: "https://bankffin.kz/files/docs/322/doc-ru-322-1646979004.pdf") else { return }
        view?.routeToWebview(title: "Сбор и обработка данных", url: url)
    }
}

extension AuthorizationInteractor: AgreementSVDelegate {

    func didChangeRadio(isSelected: Bool) {
        agreementSelected = isSelected
    }
    
    func didSelectLabel() {
        let documentIcon = BaseImage.document.uiImage
        let accessoryImage = BaseImage.chevronRight.uiImage
        let moduleItems: [BasePickerPickerItem] = [
            BasePickerPickerItem(image: documentIcon, title: "Сбор и обработка данных, хранение и распространение", accessoryImage: accessoryImage),
            BasePickerPickerItem(image: documentIcon, title: "Конфиденциальность данных", accessoryImage: accessoryImage),
            BasePickerPickerItem(image: documentIcon, title: "Пользовательское соглашение", accessoryImage: accessoryImage),
            BasePickerPickerItem(image: documentIcon, title: "Что такое FATCA", accessoryImage: accessoryImage),
            BasePickerPickerItem(image: documentIcon, title: "Кто такой бенефициарный владелец счёта", accessoryImage: accessoryImage)
        ]
        let module = BottomSheetPickerViewController<DocumentListCell>()
        let viewModel = BottomSheetPickerViewModel(title: "Условия пользователя", id: UUID(), selectedIndex: -1, items: moduleItems, delegate: self)
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)
        
        view?.presentDocumentList(module: module)
    }
}

extension AuthorizationInteractor: SIVConfirmButtonDelegate {

    func confirmButtonAction(text: String, id: UUID) {
        switch id {
        case idSIVIIN:
            openIdentity()
        default: break
        }
    }
}

extension AuthorizationInteractor: InformPUButtonDelegate {

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

extension AuthorizationInteractor: OZLivenessDelegate {
    func onOZLivenessResult(results: [Media]) {
        view?.routeToLoader()
    }

    func onError(status: OZVerificationStatus?) {
        openNotAcceptBank()
    }
}
