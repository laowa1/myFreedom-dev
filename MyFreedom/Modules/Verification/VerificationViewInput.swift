//
//  VerificationViewInput.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import Foundation

protocol VerificationViewInput: BaseViewControllerProtocol {
    
    func set(phone: String)
    func set(resendTime: TimeInterval)
    func setResendState(enabled: Bool)
    func confirm()
    func fail(message: String)
}
