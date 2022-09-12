//
//  EmailVerificationInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/13/22.
//

import Foundation

protocol SixDigitVerificationInteractorInput {

    func getId() -> UUID
    func invalidateTimer()
    func setResendTime()
    func runTimer()
}
