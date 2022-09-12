//
//  EmailVerificationInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/13/22.
//

import UIKit

class SixDigitVerificationInteractor {

    private unowned let view: SixDigitVerificationViewInput
    private weak var timer: Timer?
    private let totalResendTime: TimeInterval
    private var resendTime: TimeInterval
    private var id: UUID

    init(view: SixDigitVerificationViewInput, resendTime: TimeInterval, id: UUID) {
        self.view = view
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

extension SixDigitVerificationInteractor: SixDigitVerificationInteractorInput {

    func getId() -> UUID { id }

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
