//
//  PDBCardContainerRouterInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import Foundation

protocol PDBCardContainerRouterInput {
    
    func popViewContoller()
    func routeToRequsites(viewModel: RequisiteViewModel)
    func routeToReference()
    func routeToConditions()
    func routeToLimits()
    func routeToOrder(type: OrderPlasticCardType)
    func routeToIncomeCard()
}
