//
//  PasscodeInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.04.2022.
//

import Foundation

protocol PasscodeInteractorInput {

    func configure()
    func passItem(at index: Int)
    func authorizeIfRequested()
    func isEmptyCode() -> Bool
}

class PasscodeInteractor {

    private unowned let view: PasscodeViewInput

    private var code = ""
    private var maxIncorrectAttempts = 5
    private var incorrectAttempts = 0
    private let biometric = Biometric()
    private let keyValueStore = KeyValueStore()

    init(view: PasscodeViewInput) {
        self.view = view
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
            incorrectAttempts += 1
            guard incorrectAttempts < maxIncorrectAttempts else {
                disablePasscodeUsage()
                view.show(warning: "Превышено количество неверных попыток ввода ПИН-кода")
                cleanDots()
                return
            }

            view.set(with: Array(repeating: BaseColor.red700, count: 4))
            
            view.showAlertWithOkAction(
                title: "Неверный пинкод. Попробуйте еще раз",
                message: nil,
                okActionHandler: { [weak self] in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.cleanDots()
                    }
                }
            )
            
            return
        }

        view.login()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.cleanDots()
        }
    }

    private func updateDots() {
        var colors = Array(repeating: BaseColor.green500, count: code.count)
        for _ in code.count..<4 { colors.append(BaseColor.base200) }
        view.set(with: colors)
    }

    private func disablePasscodeUsage() {
        try? KeychainPasswordItem(
            service: KeychainConfiguration.serviceName,
            account: KeychainConfiguration.passcodeKey,
            accessGroup: KeychainConfiguration.accessGroup
        ).deleteItem()

        keyValueStore.removeValue(for: .usePasscodeToUnlock)
        keyValueStore.removeValue(for: .useBiometryToUnlock)
    }

    private func passBiometry() {
        biometric.authenticate { [weak self] result in
            guard let interactor = self else { return }

            switch result {
            case .success:
                interactor.view.login()
            case .cancelled:
                break
            case .failure:
                let message = "Ранее было запрещено использование "
                    + interactor.biometric.biometricType.title
                    + ". Для разрешения перейдите в системные Настройки приложения"
                
                interactor.view.showAlert(
                    title: "Настройки",
                    message: message,
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
    
    private func cleanDots() {
        code = ""
        updateDots()
    }
}

extension PasscodeInteractor: PasscodeInteractorInput {

    func configure() {
        if keyValueStore.getValue(for: .useBiometryToUnlock) != true {
            view.hideBiometryButton()
        }
    }

    func passItem(at index: Int) {
        switch index {
        case 9:
            view.showAlert(
                title:  "Вы уверены, что хотите выйти?",
                message: "Текущий код доступа будет сброшен",
                first: .init(title: "Отменить", style: .cancel, handler: nil),
                second: .init(title: "Да, выйти", style: .default, handler: { [weak self] _ in
                    self?.disablePasscodeUsage()
                    self?.view.closeSession()
                })
            )
        case 11:
            if code.count > 0 {
                _ = code.popLast()
                updateDots()
            } else {
                passBiometry()
            }
        default:
            if code.count < 4 {
                code += String((index + 1) % 11)
                updateDots()
            }

            if code.count == 4 {
                verify(passcode: code)
            }
        }
    }

    func authorizeIfRequested() {
        guard keyValueStore.getValue(for: .useBiometryToUnlock) == true else { return }
        passBiometry()
    }
    
    func isEmptyCode() -> Bool { code.isEmpty }
}
