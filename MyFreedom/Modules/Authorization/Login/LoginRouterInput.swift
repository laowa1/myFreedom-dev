//
//  LoginRouterInput.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 31.03.2022.
//

import Foundation

protocol LoginRouterInput: AnyObject {
    
    func routeToComeUpCode()
    func routeToPasswordRecovery(phone: String)
    func routeToChangingPhoneNumber(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToVerification(phone: String)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
}
