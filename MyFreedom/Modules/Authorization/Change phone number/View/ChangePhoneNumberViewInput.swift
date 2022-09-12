//
//  ChangePhoneNumberViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.04.2022.
//

import UIKit

protocol ChangePhoneNumberViewInput: BaseViewControllerProtocol {

    func routeToVerification(phone: String, id: UUID)
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToComeUpCode()
    func routeToLoader()
}
