//
//  ChangePhoneNumber.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.04.2022.
//

import Foundation

protocol ChangePhoneNumberRouterInput {
    func popToRoot()
    func routeToVerification(phone: String, id: UUID)
    func routeToRegistration()
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToComeUpCode()
    func routeToLoader()
}
