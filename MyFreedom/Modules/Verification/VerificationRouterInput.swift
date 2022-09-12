//
//  VerificationRouterInput.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import Foundation

protocol VerificationParentRouter: AnyObject {
    func confirm(id: UUID)
    func fail(id: UUID)
    func resend(id: UUID)
}
 
protocol VerificationRouterInput: VerificationParentRouter {
    func routeToBack()
    func routeToChangeNumber()
}
