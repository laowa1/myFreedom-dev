//
//  AuthorizationViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.04.2022.
//

import UIKit

protocol AuthorizationViewInput: BaseViewControllerProtocol {

    func agreement(isSelected: Bool)
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
    func routeToVerification(phone: String, id: UUID)
    func routeToEnterIIN(delegate: SIVConfirmButtonDelegate, id: UUID)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToComeUpCode()
    func routeToWebview(title: String, url: URL)
    func routeToLoader()
}
