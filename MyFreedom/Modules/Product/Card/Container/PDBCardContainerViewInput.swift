//
//  PDBCardContainerViewInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

protocol PDBCardContainerViewInput: PullableSheetScrollProtocol, UIViewControllerTransitioningDelegate {
    func update(at indexPath: IndexPath)
    func reloadData()
    func routeToConditions()
    func routeToReference()
    func routeToRequsites(viewModel: RequisiteViewModel)
    func routeToLimits()
    func routeToOrder(type: OrderPlasticCardType)
    func routeToIncomeCard()
}
