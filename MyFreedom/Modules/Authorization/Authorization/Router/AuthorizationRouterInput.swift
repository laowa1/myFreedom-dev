//
//  AuthorizationRouterInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.04.2022.
//

import Foundation

protocol AuthorizationRouterInput {
    func popToRoot()
    func routeToVerification(phone: String, id: UUID)
    func routeToRegistration()
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToComeUpCode()
    func routeToWebview(title: String, url: URL)
    func routeToLoader()
}
