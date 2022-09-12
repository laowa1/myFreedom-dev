//
//  VerificationInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import UIKit

class VerificationInteractor {

    private unowned let view: VerificationViewInput
    private let type: VerificationType
    private var phone: String
    private weak var timer: Timer?
    private let totalResendTime: TimeInterval
    private var resendTime: TimeInterval
    private var id: UUID

    init(view: VerificationViewInput, phone: String, type: VerificationType, resendTime: TimeInterval, id: UUID) {
        self.view = view
        self.phone = phone
        self.type = type
        self.resendTime = resendTime
        self.totalResendTime = resendTime
        self.id = id
    }
    
    @objc private func didUpdate(_ timer: Timer) {
        resendTime -= 1
        view.set(resendTime: resendTime)
        if resendTime <= 0 {
            timer.invalidate()
            view.setResendState(enabled: true)
        }
    }
}

extension VerificationInteractor: VerificationInteractorInput {
    
    func getId() -> UUID { id }
    
    func getPhone() -> String { phone }

    func getType() -> VerificationType { type }
    
    func setPhoneNumber() {
        view.set(phone: String(phone.enumerated().map { [4, 5, 7, 8, 9].contains($0.offset) ? "*" : $0.element }))
    }

    func setResendTime() {
        view.set(resendTime: resendTime)
        view.setResendState(enabled: resendTime <= 0)
    }

    func runTimer() {
        resendTime = totalResendTime
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(didUpdate),
            userInfo: nil,
            repeats: true
        )
        setResendTime()
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
}
