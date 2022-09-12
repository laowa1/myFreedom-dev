//
//  LoginInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import Foundation

protocol LoginInteractorInput: AnyObject {
    
    func openIdentity()
    func changePhone()
    func openEnterIIN()
}

class LoginInteractor {

    private unowned let view: LoginViewInput
    private let idIdentity = UUID()
    private let idNotCorrespond = UUID()
    private let idSIVPhone = UUID()
    private let idSIVIIN = UUID()
    
    init(view: LoginViewInput) {
        self.view = view
    }
    
    private func notCorrespond() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Подтвердите вашу личность"),
            subtitleText: "Пожалуйста, напишите в Службу поддержки",
            image: .camera,
            buttons: [.init(type: .confirm, title: "Служба поддержки", isGreen: true)],
            hiddenBack: true,
            id: idNotCorrespond
        )
        view.routeToInformConfirmIdentity(model: model, delegate: self)
    }
}

extension LoginInteractor: LoginInteractorInput {
    
    func openIdentity() {
        let model = InformPUViewModel(
            titleText: NSAttributedString(string: "Идентификация неуспешна"),
            subtitleText: "Убедитесь, что ваше лицо освещено, и держите камеру на уровне глаз",
            image: .binoculars,
            buttons: [.init(type: .confirm, title: "Служба поддержки", isGreen: true)],
            hiddenBack: true,
            id: idIdentity
        )
        view.routeToInformConfirmIdentity(model: model, delegate: self)
    }
    
    func changePhone() {
        view.routeToChangingPhoneNumber(delegate: self, id: idSIVPhone)
    }
    
    func openEnterIIN() {
        view.routeToEnterIIN(delegate: self, id: idSIVIIN)
    }
}

extension LoginInteractor: InformPUButtonDelegate {
    
    func buttonPressed(type: InformPUButtonType, id: UUID) {
        switch type {
        default: break
        }
        
        switch id {
        case idIdentity:
            notCorrespond()
        case idNotCorrespond:
            print(1234)
        default: break
        }
    }
}

extension LoginInteractor: SIVConfirmButtonDelegate {
    
    func confirmButtonAction(text: String, id: UUID) {
        switch id {
        case idSIVPhone:
            view.routeToVerification(phone: text)
        case idSIVIIN:
            openIdentity()
        default: break
        }
    }
}
