//
//  ProfileRouterInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import Foundation

protocol ProfileRouterInput {
    
    func popViewContoller()
    func routeToAddEmail(delegate: AddEmailDelegate)
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
    func updateAllViews()
    func routeToEnterCurrentAC(type: String, delegate: AccessCodeConfirmFaceDelegate)
    func routeToChangeAC(delegate: AccessCodeChangeDelegate)
    func routeChangeNumber(delegate: ChangePhoneDelegate)
    func routeToActivateDigitalDocument()
    func routeToDigitalDocumentStories()
    func routeToDigitalDocument(title: String, url: URL)
    func closeSession()
}
