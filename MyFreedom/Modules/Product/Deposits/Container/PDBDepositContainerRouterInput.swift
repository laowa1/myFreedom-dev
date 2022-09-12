//
//  PDBDepositContainerRouterInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import Foundation

protocol PDBDepositContainerRouterInput {
    
    func popViewContoller()
    func routeToRequsites(viewModel: RequisiteViewModel)
    func routeToReference()
    func routeToConditions()
    func routeToDepositReward()
}
