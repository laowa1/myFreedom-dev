//
//  HomeRouterInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import Foundation

protocol HomeRouterInput: AnyObject {

    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
    func routeToProfile(animated: Bool)
    func routeToCardDetail(type: PDBCardType)
    func routeToAccountDetail()
    func routeToDepositsDetail(type: PDBDepositType)
    func routeToJuniorCardPresentation()
    func routeToDeposit()
}
