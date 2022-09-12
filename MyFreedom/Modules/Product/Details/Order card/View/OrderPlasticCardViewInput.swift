//
//  OrderCardViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

protocol OrderPlasticCardViewInput: BaseViewControllerProtocol {
    func reload()
    func reloadCell(at indexPath: IndexPath)
}
