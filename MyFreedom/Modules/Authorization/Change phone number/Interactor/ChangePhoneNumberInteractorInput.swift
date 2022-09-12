//
//  ChangePhoneNumberInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.04.2022.
//

import Foundation

protocol ChangePhoneNumberInteractorInput {
    func checkingPhoneNumber(phone: String)
    func openEnterIIN()
    func validate(with id: UUID)
    func isHiddenBackButton() -> Bool
    func validatePhone()
}
