//
//  ProfileViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import UIKit

protocol ProfileViewInput: BaseViewController, UIViewControllerTransitioningDelegate {
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
    func updateAllViews()
    func update(at indexPath: IndexPath)
    func reloadData()
    func routeToEnterCurrentAC(type: String, delegate: AccessCodeConfirmFaceDelegate)
    func routeToChangeAC(delegate: AccessCodeChangeDelegate)
    func routeChangeNumber(delegate: ChangePhoneDelegate)
    func routeToAddEmail(delegate: AddEmailDelegate)
    func routeToActivateDigitalDocuments()
    func routeToDigitalDocumentStories()
    func routeToDigitalDocument()
}
