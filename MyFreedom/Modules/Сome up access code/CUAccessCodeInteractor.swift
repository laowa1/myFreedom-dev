//
//  CUAccessCodeInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 31.03.2022.
//

import Foundation
import UIKit.UIApplication

class CUAccessCodeInteractor {

    private unowned let view: CUAccessCodeViewInput
    private weak var delegate: AccessCodeDelegate?
    private var code = ""
    private var confirmationCode = ""
    private var type: CUAccessCodeType
    private let biometric = Biometric()
    private let keyValueStore = KeyValueStore()
    private let connectId = UUID()
    private let notificationId = UUID()
    private let cardIssueId = UUID()

    init(delegate: AccessCodeDelegate?, confirmationCode: String, type: CUAccessCodeType, view: CUAccessCodeViewInput) {
        self.delegate = delegate
        self.confirmationCode = confirmationCode
        self.type = type
        self.view = view
    }

    private func updateDots() {
        var colors = Array(repeating: BaseColor.green500, count: code.count)
        for _ in code.count..<4 { colors.append(BaseColor.base200) }
        view.set(with: colors)
    }
    
    private func cleanDots() {
        code = ""
        updateDots()
    }

    private func saveCode() {
        let passcodeItem = KeychainPasswordItem(
            service: KeychainConfiguration.serviceName,
            account: KeychainConfiguration.passcodeKey,
            accessGroup: KeychainConfiguration.accessGroup
        )

        // Store passcode in keychain
        do {
            try passcodeItem.savePassword(code)
            keyValueStore.set(value: true, for: .usePasscodeToUnlock)
            
            switch type {
            case .repeatNew:
                view.navigationController?.popViewControllers(viewsToPop: 3, animated: true)
                (delegate as? AccessCodeChangeDelegate)?.confirmChange()
            case .repeat:
                if biometric.biometricType == .face || biometric.biometricType == .touch {
                    showInformAllowConnect()
                }
            default: break
            }
        } catch let error {
            guard let keychainError = error as? KeychainPasswordItem.KeychainError else {
                fatalError("Keychain error: \(error)")
            }

            switch keychainError {
            case .noPassword: break
            default: fatalError("Keychain error: \(error)")
            }
        }
    }

    private func confirmFace() {
        biometric.authenticate { [weak self] result in
            guard let interactor = self else { return }

            switch result {
            case .success:
                interactor.keyValueStore.set(value: true, for: .useBiometryToUnlock)
                interactor.showAllowNotifications()
            case .cancelled:
                break
            case .failure:
                interactor.view.showAlert(
                    title: "Биометрия недоступна",
                    message: "Для разрешения перейдите в системные Настройки приложения",
                    style: .alert,
                    actions: [
                        .init(title: "Настройки", style: .default, handler: { _ in
                            interactor.view.openSettings()
                        }),
                        .init(title: "Отмена", style: .cancel, handler: nil)
                    ]
                )
            }
        }
    }

    private func showInformAllowConnect() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Подключите вход по \(biometric.biometricType.title)"),
            subtitleText: "Это быстро и безопасно",
            image: .lock,
            buttons: [
                .init(type: .confirm, title: "Подключить", isGreen: true),
                .init(type: .cancel, title: "Не сейчас", isGreen: false)
            ],
            hiddenBack: true,
            id: connectId
        )

        view.routeToInform(deledate: self, model: model)
    }

    private func showAllowNotifications() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Разрешите уведомления"),
            subtitleText: "Получайте актуальные обновления по вашим счетам",
            image: .calendar,
            buttons: [
                .init(type: .confirm, title: "Разрешить", isGreen: true),
                .init(type: .cancel, title: "Не сейчас", isGreen: false)
            ],
            hiddenBack: false,
            id: notificationId
        )

        view.routeToInform(deledate: self, model: model)
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
        mainText.append(NSAttributedString(string: " FREEDOM CARD ", attributes: attrs1))
        mainText.append(NSAttributedString(string: "почти готова!", attributes: attrs))
        let model = InformPUViewModel(
            titleText: mainText,
            subtitleText: "Это бесплатная мультивалютная цифровая карта. С ней вы сможете пользоваться всеми сервисами приложения без комиссий.",
            image: .yourFreedomCardIsReady,
            buttons: [.nextButton],
            id: cardIssueId,
            url: "https://bankffin.kz/files/docs/322/doc-ru-322-1646979004.pdf",
            urlTitle: "Ознакомиться с заявлением на открытие карты"
        )
        view.routeToInform(deledate: self, model: model)
    }
    
    private func verify(passcode: String) {
        let storedPasscode: String
        let passcodeItem = KeychainPasswordItem(
            service: KeychainConfiguration.serviceName,
            account: KeychainConfiguration.passcodeKey,
            accessGroup: KeychainConfiguration.accessGroup
        )

        do {
            storedPasscode = try passcodeItem.readPassword()
        } catch {
            if let keychainError = error as? KeychainPasswordItem.KeychainError {
                view.showAlert(
                    title: keychainError.description,
                    message: nil,
                    first: .init(title: "Выйти", style: .destructive, handler: { [weak self] _ in
                        self?.view.closeSession()
                    })
                )
                
                cleanDots()
            } else {
                view.show(warning: "Ошибка")
            }
            return
        }

        guard passcode == storedPasscode else {
            view.showAlertOnTop(withMessage: "Неверный пинкод. Попробуйте еще раз")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.cleanDots()
                self?.view.view.isUserInteractionEnabled = true
            }
            
            return
        }
        
        if case .confirmFace(_) = self.type {
            view.navigationController?.popViewController(animated: true)
            (delegate as? AccessCodeConfirmFaceDelegate)?.confirmFace()
        } else {
            view.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self = self else { return }
                self.view.view.isUserInteractionEnabled = true
                self.view.routeToRepeat(code: "", popToRoot: false, type: .new)
                self.confirmationCode = ""
                self.code = ""
                self.updateDots()
            }
        }
    }
}

extension CUAccessCodeInteractor: CUAccessCodeInteractorInput {

    func passItem(at index: Int) {
        switch index {
        case 9: // Go out
            break
        case 11:
            _ = code.popLast()
            updateDots()
        default:
            if code.count < 4 {
                code += String((index + 1) % 11)
                updateDots()
            }

            if code.count == 4 {
                if confirmationCode.isEmpty {
                    view.view.isUserInteractionEnabled = false
                    if delegate != nil, ![CUAccessCodeType.repeatNew, CUAccessCodeType.new].contains(type) {
                        verify(passcode: code)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                            guard let self = self else { return }
                            self.view.view.isUserInteractionEnabled = true
                            self.view.routeToRepeat(code: self.code, popToRoot: true, type: self.delegate == nil ? .repeat : .repeatNew)
                            self.confirmationCode = ""
                            self.code = ""
                            self.updateDots()
                        }
                    }
                } else if confirmationCode == code {
                    saveCode()
                } else {
                    view.view.isUserInteractionEnabled = false
                    self.view.set(with: Array(repeating: BaseColor.red700, count: 4))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.view.view.isUserInteractionEnabled = true
                        self.view.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    func getType() -> CUAccessCodeType { type }
}

extension CUAccessCodeInteractor: InformPUButtonDelegate {

    func buttonPressed(type: InformPUButtonType, id: UUID) {
        switch type {
        case .confirm:
            switch id {
            case connectId:
                confirmFace()
            case notificationId:
                (UIApplication.shared.delegate as? AppDelegate)?.configureNotifications()
                keyValueStore.set(value: true, for: .enablePush)
                cardIssue()
            case cardIssueId:
                view.login()
            default:
                break
            }
        case .cancel:
            switch id {
            case connectId:
                showAllowNotifications()
            case notificationId:
                keyValueStore.set(value: false, for: .enablePush)
                cardIssue()
            default:
                break
            }
        case .destructive:
            break
        }
    }
}
