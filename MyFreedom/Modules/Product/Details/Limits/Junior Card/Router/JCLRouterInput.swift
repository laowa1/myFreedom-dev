//
//  JCLRouterInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import Foundation

protocol JCLRouterInput {
    func presentDetail()
    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol)
    func popViewContoller()
    func closeSession()
    func routeToBlockedPayments()
}
