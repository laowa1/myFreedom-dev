//
//  PDBAccountContainerRouterInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import Foundation

protocol PDBAccountContainerRouterInput {
    
    func popViewContoller()
    func routeToRequsites(viewModel: RequisiteViewModel)
    func routeToReference()
    func routeToConditions()
}
