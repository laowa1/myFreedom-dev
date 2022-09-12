//
//  PDLimitsViewInput.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import Foundation

protocol PDLimitsViewInput: BaseViewController {
    
    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol)
    func update(at indexPath: IndexPath)
    func reloadData()
}
