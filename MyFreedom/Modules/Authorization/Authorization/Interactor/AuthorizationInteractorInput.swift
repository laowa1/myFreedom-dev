//
//  AuthorizationInteractorInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.04.2022.
//

import Foundation

protocol AuthorizationInteractorInput {
    var agreementSelected: Bool { get set }
    func getAgreementModel() -> AgreementSVModel
    func checkingPhoneNumber(phone: String)
    func openEnterIIN()
    func validate(with id: UUID)
    func isHiddenBackButton() -> Bool
    func validatePhone()
    func testLog()
}
