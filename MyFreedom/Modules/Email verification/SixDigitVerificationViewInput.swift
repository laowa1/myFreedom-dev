//
//  EmailVerificationViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/13/22.
//

import Foundation

protocol SixDigitVerificationViewInput: BaseViewControllerProtocol {
    func set(resendTime: TimeInterval)
    func setResendState(enabled: Bool)
    func confirm()
    func fail(message: String)
}
