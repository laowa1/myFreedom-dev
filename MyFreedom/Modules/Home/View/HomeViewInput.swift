//
//  HomeViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import UIKit.UIViewControllerTransitioning

protocol HomeViewInput: BaseViewControllerProtocol, UIViewControllerTransitioningDelegate {
    
    func reload()
    func routeToCardDetail(type: PDBCardType)
    func routeToAccountDetail()
    func routeToDepositsDetail(type: PDBDepositType)
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
    func routeToDeposit()
    func routeToJuniorCardPresentation()
    func routeToOpenInvestCard()
}
