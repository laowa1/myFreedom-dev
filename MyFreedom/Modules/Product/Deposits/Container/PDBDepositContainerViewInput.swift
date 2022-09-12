//
//  PDBDepositContainerViewInput.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

protocol PDBDepositContainerViewInput: PullableSheetScrollProtocol, UIViewControllerTransitioningDelegate {
    func update(at indexPath: IndexPath)
    func reloadData()
    func routeToConditions()
    func routeToReference()
    func routeToRequsites(viewModel: RequisiteViewModel)
    func routeToDepositReward()
}
