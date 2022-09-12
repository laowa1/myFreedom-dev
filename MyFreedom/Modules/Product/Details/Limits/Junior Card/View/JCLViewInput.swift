//
//  JCLViewInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import Foundation

protocol JCLViewInput: BaseViewController {
    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol)
    func update(at indexPath: IndexPath)
    func reloadData()
}
